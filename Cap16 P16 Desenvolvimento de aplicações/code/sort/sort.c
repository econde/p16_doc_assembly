#include <stdint.h>

typedef	enum boolean {false = 0, true = !false} Boolean;

void sort(uint16_t a[], int dim)  {
    Boolean swapped;
    do {
        swapped = false;
        for (int i = 0; i < dim - 1; i++)
            if ( a[i] > a[i + 1]) {
                int aux = a[i];
                a[i] = a[i + 1];
                a[i + 1] = aux;
                swapped = true;
            };
        dim--;
    } while (swapped);
}

uint16_t array[] = { 20, 3, 45, 7, 5, 9, 15, 2};

int main() {
	sort(array, sizeof(array) / sizeof(array[0]));
}
