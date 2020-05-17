#include <stdio.h>

#include "SDL.h"
#include "SDL_image.h"

extern unsigned long long int tsCount();
extern void fadeShiftAsm(unsigned char* buf, int width, int height);

void fadeShiftC(unsigned char* buf, int width, int height) {
    unsigned long long int size = width * height;
    while (size--) {
        *(buf) = (*buf / 4) * 3 + (*(buf + 50) / 4);
        ++buf;
    }
}

SDL_Surface* loadImage(const char* fileName) {
    return IMG_Load(fileName);
}

void Paint(SDL_Surface* image, SDL_Surface* screen) {
    SDL_BlitSurface(image, NULL, screen, NULL);
    SDL_UpdateRect(screen, 0, 0, 0, 0);
};

int main(const int argc, const char* argv[]) {
    SDL_Event event;

    SDL_Init(SDL_INIT_VIDEO);
    SDL_Surface *image = loadImage(argv[1]);
    SDL_WM_SetCaption(argv[1], "lab8");
    SDL_Surface *screen = SDL_SetVideoMode(image->w, image->h, 8, (Uint32) SDL_SWSURFACE);

    if (image->format->palette) {
        SDL_SetColors(screen, image->format->palette->colors,
                      0, image->format->palette->ncolors);
    }

    Paint(image, screen);
    unsigned long long int timerStart = 0, timerEnd = 0;
    int done = 0;
    while (!done) {
        if (SDL_PollEvent(&event)) {
            switch (event.type) {
                case SDL_KEYUP:
                    switch (event.key.keysym.sym) {
                        case SDLK_q:
                            done = 1;
                            break;
                        case SDLK_f:
                            SDL_LockSurface(image);

                            timerStart = tsCount();
                            fadeShiftC(image->pixels, image->w, image->h);
                            timerEnd = tsCount();
                            printf("C   done in %llu cycles.\n", timerEnd - timerStart);

                            SDL_UnlockSurface(image);

                            Paint(image, screen);
                            break;
                        case SDLK_g:
                            SDL_LockSurface(image);

                            timerStart = tsCount();
                            fadeShiftAsm(image->pixels, image->w, image->h);
                            timerEnd = tsCount();
                            printf("Asm done in %llu cycles.\n", timerEnd - timerStart);

                            SDL_UnlockSurface(image);

                            Paint(image, screen);
                            break;
                        case SDLK_r:
                            image = loadImage(argv[1]);
                            Paint(image, screen);
                            printf("\nReloaded!\n\n");
                            break;
                        default:
                            break;
                    }
                    break;
                case SDL_QUIT:
                    done = 1;
                    break;
                default:
                    break;
            }
        }
    }
    SDL_FreeSurface(image);
    SDL_Quit();
    return 0;
}
