#include <iostream>
#include <libusb.h>
#include <stdio.h>

using namespace std;

const char* get_class_name(uint8_t deviceClass) {
    switch (deviceClass) {
        case 0x00: return "Код отсутствует";
        case 0x01: return "Аудиоустройство";
        case 0x02: return "Коммуникационное устройство (Сетевой адаптер)";
        case 0x03: return "Устройство пользовательского интерфейса";
        case 0x05: return "Физическое устройство";
        case 0x06: return "Изображения";
        case 0x07: return "Принтер";
        case 0x08: return "Устройство хранения данных";
        case 0x09: return "Концентратор";
        case 0x0A: return "CDC-Data";
        case 0x0B: return "Smart Card";
        case 0x0D: return "Content Security";
        case 0x0E: return "Видеоустройство";
        case 0x0F: return "Персональное медицинское устройство";
        case 0x10: return "Аудио- и видеоустройства";
        case 0xDC: return "Диагностическое устройство";
        case 0xE0: return "Беспроводный контроллер";
        case 0xEF: return "Различные устройства";
        case 0xFE: return "Специфическое устройство";
        default:   return "Неизвестный класс";
    }
}

int main() {
    libusb_device **devs;
    libusb_context *ctx = NULL;
    int r;
    ssize_t cnt;

    r = libusb_init(&ctx);
    if (r < 0) {
        fprintf(stderr, "Ошибка: инициализация не выполнена, код: %d (%s).\n", r, libusb_error_name(r));
        return 1;
    }

    cnt = libusb_get_device_list(ctx, &devs);
    if (cnt < 0) {
        fprintf(stderr, "Ошибка: список USB устройств не получен.\n");
        libusb_exit(ctx);
        return 1;
    }

    printf("Найдено устройств: %zd\n", cnt);
    printf("\n");

    for (ssize_t i = 0; i < cnt; i++) {
        libusb_device_descriptor desc;
        
        r = libusb_get_device_descriptor(devs[i], &desc);

        if (r < 0) {
            continue;
        }

        printf("Устройство %zd:\n", i + 1);
        printf("  ID производителя: 0x%04X\n", desc.idVendor);
        printf("  ID изделия:       0x%04X\n", desc.idProduct);
        printf("  Класс устройства: 0x%02X (%s)\n", desc.bDeviceClass, get_class_name(desc.bDeviceClass));

        libusb_device_handle *handle = NULL;
        r = libusb_open(devs[i], &handle);
        
        if (r == 0 && handle != NULL) {
            unsigned char buffer[256];
            int str_len;

            if (desc.iManufacturer != 0) {
                str_len = libusb_get_string_descriptor_ascii(handle, desc.iManufacturer, buffer, sizeof(buffer));
                if (str_len > 0) {
                    printf("  Производитель: %s\n", buffer);
                } 
            }

            if (desc.iProduct != 0) {
                str_len = libusb_get_string_descriptor_ascii(handle, desc.iProduct, buffer, sizeof(buffer));
                if (str_len > 0) {
                    printf("  Название изделия: %s\n", buffer);
                }
            }

            if (desc.iSerialNumber != 0) {
                str_len = libusb_get_string_descriptor_ascii(handle, desc.iSerialNumber, buffer, sizeof(buffer));
                if (str_len > 0) {
                    printf("  Серийный номер: %s\n", buffer);
                }
            }

            libusb_close(handle);
        } else {
            printf("  Производитель: (нет доступа)\n");
            printf("  Название изделия: (нет доступа)\n");
            printf("  Серийный номер: (нет доступа)\n");
        }
        printf("\n");
    }

    libusb_free_device_list(devs, 1);
    libusb_exit(ctx);

    return 0;
}
