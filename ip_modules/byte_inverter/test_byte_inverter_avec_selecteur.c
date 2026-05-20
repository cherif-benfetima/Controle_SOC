#include <stdio.h>
#include "system.h"
#include "io.h"

#define BYTESWAP_BASE  BYTE_INVERTER_AVALON_0_BASE

#define REG_INPUT   0x00   /* mot à inverser      */
#define REG_SEL     0x04   /* sélecteur opération */
#define REG_OUTPUT  0x08   /* résultat            */

#define OP_FULL_SWAP  0    /* [O0|O1|O2|O3] */
#define OP_PAIR_SWAP  1    /* [O1|O0|O3|O2] */

int main(void) {
    unsigned int input  = 0x12345678;
    unsigned int result;

    printf("=== Test Byte Inverter avec selecteur ===\n\n");
    printf("Entree : 0x%08X\n\n", input);

    /* Ecriture du mot d'entrée */
    IOWR_32DIRECT(BYTESWAP_BASE, REG_INPUT, input);

    /* --- Opération 0 : inversion complète --- */
    IOWR_32DIRECT(BYTESWAP_BASE, REG_SEL, OP_FULL_SWAP);
    result = IORD_32DIRECT(BYTESWAP_BASE, REG_OUTPUT);
    printf("OP0 - Inversion complete  : 0x%08X\n", result);
    printf("Attendu                   : 0x78563412  %s\n\n",
           result == 0x78563412 ? "OK" : "ERREUR");

    /* --- Opération 1 : inversion par paires --- */
    IOWR_32DIRECT(BYTESWAP_BASE, REG_SEL, OP_PAIR_SWAP);
    result = IORD_32DIRECT(BYTESWAP_BASE, REG_OUTPUT);
    printf("OP1 - Inversion par paires: 0x%08X\n", result);
    printf("Attendu                   : 0x21436587  %s\n\n",
           result == 0x21436587 ? "OK" : "ERREUR");

    printf("=== Fin ===\n");
    return 0;
}