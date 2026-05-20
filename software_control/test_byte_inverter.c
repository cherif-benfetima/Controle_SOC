#include <stdio.h>
#include "system.h"
#include "io.h"

/* Adresses depuis system.h (après ajout dans Qsys) */
#define BYTESWAP_BASE   BYTE_INVERTER_AVALON_0_BASE

#define REG_INPUT  0x00   /* écriture du mot à inverser */
#define REG_OUTPUT 0x04   /* lecture du résultat        */

int main(void) {
    unsigned int input, result;
    int i;

    /* Vecteurs de test */
    unsigned int test_vectors[4] = {
        0x12345678,
        0xAABBCCDD,
        0x00FF00FF,
        0xDEADBEEF
    };
    unsigned int expected[4] = {
        0x78563412,
        0xDDCCBBAA,
        0xFF00FF00,
        0xEFBEADDE
    };

    printf("=== Test Byte Inverter ===\n\n");

    for (i = 0; i < 4; i++) {
        input = test_vectors[i];

        /* Écriture du mot à inverser */
        IOWR_32DIRECT(BYTESWAP_BASE, REG_INPUT, input);

        /* Lecture du résultat */
        result = IORD_32DIRECT(BYTESWAP_BASE, REG_OUTPUT);

        /* Affichage et vérification */
        printf("Entree  : 0x%08X\n", input);
        printf("Resultat: 0x%08X\n", result);
        printf("Attendu : 0x%08X\n", expected[i]);
        printf("Status  : %s\n\n",
               result == expected[i] ? "OK ✅" : "ERREUR ❌");
    }

    printf("=== Fin des tests ===\n");
    return 0;
}