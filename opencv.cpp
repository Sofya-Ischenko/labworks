#include <opencv2/opencv.hpp>
#include <iostream>
#include <time.h> 

double get_time_sec(clockid_t clock_type) {
    struct timespec ts;
    clock_gettime(clock_type, &ts);
    return ts.tv_sec + (ts.tv_nsec / 1000000000.0);
}

class PerformanceTracker {
private:
    double time_input;
    double time_process;
    double time_display;

    double program_start_time;
    int total_frames;

public:
    PerformanceTracker() {
        time_input = 0.0;
        time_process = 0.0;
        time_display = 0.0;
        total_frames = 0;
        program_start_time = get_time_sec(CLOCK_MONOTONIC);
    }

    void addTimes(double t_input, double t_process, double t_display) {
        time_input += t_input;
        time_process += t_process;
        time_display += t_display;
        total_frames++;
    }

    void printFinalReport() const {
        double total_program_time = get_time_sec(CLOCK_MONOTONIC) - program_start_time;
        
        double avg_fps = total_frames / total_program_time;

        double percent_input = (time_input / total_program_time) * 100.0;
        double percent_process = (time_process / total_program_time) * 100.0;
        double percent_display = (time_display / total_program_time) * 100.0;

        std::cout << std::endl;
        std::cout << "        ИТОГОВЫЕ РЕЗУЛЬТАТЫ             " << std::endl;
        std::cout << std::endl;
        std::cout << "Всего кадров: " << total_frames << std::endl;
        std::cout << "Общее время:  " << total_program_time << " сек." << std::endl;
        std::cout << "Средний FPS:  " << avg_fps << std::endl;
        std::cout << std::endl;
        std::cout << "Доля времени процессора по этапам:" << std::endl;
        std::cout << "  Ввод:              " << percent_input << " %" << std::endl;
        std::cout << "  Преобразование:    " << percent_process << " %" << std::endl;
        std::cout << "  Показ:             " << percent_display << " %" << std::endl;
        std::cout << std::endl;
    }
};

int main() {
    cv::VideoCapture capture(0);

    if (!capture.isOpened()) {
        std::cout << "Ошибка: Камера не найдена!" << std::endl;
        return -1;
    }

    cv::Mat frame;
    cv::Mat gray_frame;
    cv::Mat blur_frame;

    PerformanceTracker tracker;

    while (true) {

        double t1_start = get_time_sec(CLOCK_PROCESS_CPUTIME_ID);
        capture >> frame;

        if (frame.empty()) 
            break;

        double t1_end = get_time_sec(CLOCK_PROCESS_CPUTIME_ID);
        double time_input = t1_end - t1_start;

        double t2_start = get_time_sec(CLOCK_PROCESS_CPUTIME_ID);
        gray_frame = frame.clone();

        for (int y = 0; y < gray_frame.rows; y++) {
            for (int x = 0; x < gray_frame.cols; x++) {
                cv::Vec3b& pixel = gray_frame.at<cv::Vec3b>(y, x);
                uchar gray = (pixel[0] + pixel[1] + pixel[2]) / 3;
                pixel[0] = gray; 
                pixel[1] = gray; 
                pixel[2] = gray;
            }
        }

        blur_frame = frame.clone();
        cv::blur(blur_frame, blur_frame, cv::Size(9, 9));
        
        double t2_end = get_time_sec(CLOCK_PROCESS_CPUTIME_ID);
        double time_process = t2_end - t2_start;

        double t3_start = get_time_sec(CLOCK_PROCESS_CPUTIME_ID);
        cv::imshow("Blur", blur_frame);
        cv::imshow("Gray", gray_frame);
        cv::imshow("Original", frame);
        double t3_end = get_time_sec(CLOCK_PROCESS_CPUTIME_ID);
        double time_display = t3_end - t3_start;

        tracker.addTimes(time_input, time_process, time_display);

        if ((char)cv::waitKey(33) == 27) 
            break; 
    }

    tracker.printFinalReport();

    capture.release();
    cv::destroyAllWindows();
    return 0;
}
