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
    int frame_count;                        // Счетчик кадров за текущую секунду
    double cpu_time;                        // Сумма времени CPU за текущую секунду
    double program_start_time;              // Время старта программы
    double real_time_start;                 // Время старта текущей секунды
    int total_frames;                       // Общее число кадров за всё время работы
    double total_cpu_time;                  // Общее время CPU за всё время работы
    double max_fps_record;                  // Рекорд: максимальный FPS за всё время
    double min_cpu_ms_record;               // Рекорд: минимальное время CPU на кадр
    double min_load_percent_record;         // Рекорд: минимальная загрузка CPU

public:
    PerformanceTracker() {
        frame_count = 0;
        cpu_time = 0.0;
        program_start_time = get_time_sec(CLOCK_MONOTONIC);
        real_time_start = program_start_time;
        total_frames = 0;
        total_cpu_time = 0.0;
        max_fps_record = 0.0;
        min_cpu_ms_record = 999999.0;
        min_load_percent_record = 100.0;
    }

    void update(double current_cpu_time) {
        cpu_time += current_cpu_time;
        frame_count++;
        total_frames++;
        total_cpu_time += current_cpu_time;

        double real_time_now = get_time_sec(CLOCK_MONOTONIC);
        
        if ((real_time_now - real_time_start) >= 1.0) {
            double fps = frame_count / (real_time_now - real_time_start);
            double avg_cpu_ms = (cpu_time / frame_count) * 1000.0;
            double total_iteration_time_ms = avg_cpu_ms + 33.0;
            double cpu_load_percent = (avg_cpu_ms / total_iteration_time_ms) * 100.0;

            std::cout << "----------------------------------------" << std::endl;
            std::cout << "FPS: " << fps << std::endl;
            std::cout << "Ср. время CPU на кадр: " << avg_cpu_ms << " мс" << std::endl;
            std::cout << "Доля загрузки CPU: " << cpu_load_percent << " %" << std::endl;

            if (fps > max_fps_record) max_fps_record = fps;
            if (avg_cpu_ms < min_cpu_ms_record) min_cpu_ms_record = avg_cpu_ms;
            if (cpu_load_percent < min_load_percent_record) min_load_percent_record = cpu_load_percent;

            frame_count = 0;
            cpu_time = 0.0;
            real_time_start = real_time_now;
        }
    }

    void printFinalReport() const {
        double total_program_time = get_time_sec(CLOCK_MONOTONIC) - program_start_time;
        double overall_avg_fps = total_frames / total_program_time;
        double overall_avg_cpu_ms = (total_cpu_time / total_frames) * 1000.0;
        double overall_avg_load = (overall_avg_cpu_ms / (overall_avg_cpu_ms + 33.0)) * 100.0;

        std::cout << std::endl;
        std::cout << "        ИТОГОВЫЕ РЕЗУЛЬТАТЫ             " << std::endl;
        std::cout << std::endl;
        std::cout << "Всего обработано кадров: " << total_frames << std::endl;
        std::cout << "Общее время работы:      " << total_program_time << " сек." << std::endl;
        std::cout <<  std::endl;
        std::cout << "Средний FPS (за все время): " << overall_avg_fps << std::endl;
        std::cout << "Среднее время CPU на кадр:  " << overall_avg_cpu_ms << " мс" << std::endl;
        std::cout << "Средняя доля загрузки CPU:  " << overall_avg_load << " %" << std::endl;
        std::cout << std::endl;
        std::cout << "         ЛУЧШИЕ ПОКАЗАТЕЛИ             " << std::endl;
        std::cout << std::endl;
        std::cout << "Максимальный FPS:         " << max_fps_record << std::endl;
        std::cout << "Минимальное время CPU:    " << min_cpu_ms_record << " мс" << std::endl;
        std::cout << "Минимальная загрузка CPU: " << min_load_percent_record << " %" << std::endl;
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
        double cpu_start = get_time_sec(CLOCK_PROCESS_CPUTIME_ID);
        capture >> frame;

        if (frame.empty()) 
            break;

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

        cv::imshow("Blur", blur_frame);
        cv::imshow("Gray", gray_frame);
        cv::imshow("Original", frame);

        double cpu_end = get_time_sec(CLOCK_PROCESS_CPUTIME_ID);
        double current_cpu_time = cpu_end - cpu_start;
        
        tracker.update(current_cpu_time);

        if ((char)cv::waitKey(33) == 27) 
            break; 
    }

    tracker.printFinalReport();

    capture.release();
    cv::destroyAllWindows();
    return 0;
}