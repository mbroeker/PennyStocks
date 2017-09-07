//
//  main.m
//  pennyStocksTool
//
//  Created by Markus Bröker on 30.04.17.
//  Copyright © 2017 Markus Bröker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Calculator.h"

#ifndef DEFAULT_TIMEOUT
#define DEFAULT_TIMEOUT 60
#endif

#ifndef DEFAULT_ROWS
#define DEFAULT_ROWS 50
#endif

typedef struct CONFIG {
    NSTimeInterval timeout;
    int rows;
} CONFIG;

/**
 * Warte timeout Sekunden
 *
 * @param timeout
 */
void safeSleep(NSTimeInterval timeout) {
    [NSThread sleepForTimeInterval:timeout];
}

/**
 * Hilfsfunktion zum Zusammenbauen der Headline
 *
 * @param checkpoint
 * @param asset
 * @return
 */
const char *makeHeadlineString(NSDictionary *checkpoint, NSString *asset) {
    NSString *format = @"1 %@ : %.2f EUR : %.2f EUR : %.2f%%";

    NSString *theHeadLine = [
        NSString stringWithFormat:format,
                                  asset,
                                  [checkpoint[CP_INITIAL_PRICE] doubleValue],
                                  [checkpoint[CP_CURRENT_PRICE] doubleValue],
                                  [checkpoint[CP_PERCENT] doubleValue]
    ];

    return [theHeadLine UTF8String];
}

/**
 * Hilfsfunktion zum Zusammenbauen der Zeile
 *
 * @param checkpoint
 * @param asset
 * @param currentRatings
 * @param btcPercent
 * @return
 */
const char *makeString(NSDictionary *checkpoint, NSString *asset, NSDictionary *currentRatings, double btcPercent) {
    double effectivePercent = [checkpoint[CP_PERCENT] doubleValue];
    if (![asset isEqualToString:ASSET1]) effectivePercent -= btcPercent;

    double currentPrice = [checkpoint[CP_CURRENT_PRICE] doubleValue];
    double currentPriceInBTC = [currentRatings[ASSET1] doubleValue] / [currentRatings[asset] doubleValue];

    NSString *theString = [
        NSString stringWithFormat:@"%.6f EUR / %.8f %@ / %+.2f%%",
                                  currentPrice,
                                  currentPriceInBTC,
                                  ASSET1,
                                  effectivePercent
    ];

    return [theString UTF8String];
}

/**
 * Die Hauptroutine dieses Daemons
 *
 * @param config
 */
void brokerRun(CONFIG config) {

    static unsigned long counter = 0;
    Calculator *calculator = [Calculator instance];

    for (;;) {
        NSDictionary *currentRatings = [calculator currentRatings];

        NSDictionary *btcCheckpoint = [calculator checkpointForAsset:ASSET1];
        NSDictionary *zecCheckpoint = [calculator checkpointForAsset:ASSET2];
        NSDictionary *ethCheckpoint = [calculator checkpointForAsset:ASSET3];
        NSDictionary *xmrCheckpoint = [calculator checkpointForAsset:ASSET4];
        NSDictionary *ltcCheckpoint = [calculator checkpointForAsset:ASSET5];

        double btcPercent = [btcCheckpoint[CP_PERCENT] doubleValue];

        if ((counter++ % config.rows) == 0) {
            printf("%%: %-43s | %-43s | %-43s | %-43s | %-43s\n",
                makeHeadlineString(btcCheckpoint, ASSET1),
                makeHeadlineString(zecCheckpoint, ASSET2),
                makeHeadlineString(ethCheckpoint, ASSET3),
                makeHeadlineString(xmrCheckpoint, ASSET4),
                makeHeadlineString(ltcCheckpoint, ASSET5)
            );
        }

        printf("%%: %-43s | %-43s | %-43s | %-43s | %-43s\n",
            makeString(btcCheckpoint, ASSET1, currentRatings, btcPercent),
            makeString(zecCheckpoint, ASSET2, currentRatings, btcPercent),
            makeString(ethCheckpoint, ASSET3, currentRatings, btcPercent),
            makeString(xmrCheckpoint, ASSET4, currentRatings, btcPercent),
            makeString(ltcCheckpoint, ASSET5, currentRatings, btcPercent)
        );

        [calculator updateRatings:false];
        safeSleep(config.timeout);
    }
}

/**
 * Kompakte Übersicht der Funktionen des Daemons
 *
 * @param name
 */
void usage(const char *name) {
    printf("Anzeige der Gewinne und Verluste beim Handeln mit Alt-Coins\n\n");
    printf("Copyright   Copyright(C) 2017 4customers UG\n");
    printf("Autor       Markus Bröker<broeker.markus@googlemail.com>\n\n");

    printf("Benutzung:  %s [OPTIONEN]\n\n", name);

    printf("Kontooptionen\n\n");

    printf("  --balance\t\tZeige den aktuellen Gesamtsaldo aller Coins an\n");
    printf("  --list\n\n");

    printf("  --%s ANZAHL\t\tSetze den aktuellen Saldo für %s\n", [[NSString stringWithFormat:@"%@", ASSET1.lowercaseString] UTF8String], ASSET1_DESC.UTF8String);
    printf("  --%s ANZAHL\t\tSetze den aktuellen Saldo für %s\n", [[NSString stringWithFormat:@"%@", ASSET2.lowercaseString] UTF8String], ASSET2_DESC.UTF8String);
    printf("  --%s ANZAHL\t\tSetze den aktuellen Saldo für %s\n", [[NSString stringWithFormat:@"%@", ASSET3.lowercaseString] UTF8String], ASSET3_DESC.UTF8String);
    printf("  --%s ANZAHL\t\tSetze den aktuellen Saldo für %s\n", [[NSString stringWithFormat:@"%@", ASSET4.lowercaseString] UTF8String], ASSET4_DESC.UTF8String);
    printf("  --%s ANZAHL\t\tSetze den aktuellen Saldo für %s\n", [[NSString stringWithFormat:@"%@", ASSET5.lowercaseString] UTF8String], ASSET5_DESC.UTF8String);

    printf("  --%s ANZAHL\t\tSetze den aktuellen Saldo für %s\n", [[NSString stringWithFormat:@"%@", ASSET6.lowercaseString] UTF8String], ASSET6_DESC.UTF8String);
    printf("  --%s ANZAHL\t\tSetze den aktuellen Saldo für %s\n", [[NSString stringWithFormat:@"%@", ASSET7.lowercaseString] UTF8String], ASSET7_DESC.UTF8String);
    printf("  --%s ANZAHL\t\tSetze den aktuellen Saldo für %s\n", [[NSString stringWithFormat:@"%@", ASSET8.lowercaseString] UTF8String], ASSET8_DESC.UTF8String);
    printf("  --%s ANZAHL\t\tSetze den aktuellen Saldo für %s\n", [[NSString stringWithFormat:@"%@", ASSET9.lowercaseString] UTF8String], ASSET9_DESC.UTF8String);
    printf("  --%s ANZAHL\t\tSetze den aktuellen Saldo für %s\n", [[NSString stringWithFormat:@"%@", ASSET10.lowercaseString] UTF8String], ASSET10_DESC.UTF8String);

    printf("ANZAHL im amerikanische Dezimalformat (0.5 anstatt 0,5)\n\n");

    printf("Allgemeine Optionen\n\n");

    printf("  --rows ROWS\t\tAnzeige der Überschrift nach ROWS Zeilen\n");
    printf("  --timeout TIMEOUT\tAktualisierungsinterval TIMEOUT in Sekunden\n");
    printf("  --reset\t\tSetze die Daten auf die Anfangseinstellungen zurück\n");
    printf("  --help\t\tZeige diese Hilfe an\n\n");

    printf("Bei Fragen und Anregungen kontaktieren Sie den Support unter +49 0151 54129488!\n");
}

/**
 * Simpler Command-Line-Parser ohne getopt
 *
 * @param argc
 * @param argv
 */
void parseOptions(int argc, const char **argv, CONFIG *config) {

    Calculator *calculator = [Calculator instance];
    double value = 0;
    BOOL update = false;

    // Exklusive Optionen, die das Programm sofort beenden
    for (int i = 1; i < argc; i++) {

        // Hilfe ist exklusiv und beendet das Programm immer!
        if (!strcmp(argv[i], "--help") || !strcmp(argv[i], "-h")) {
            usage(argv[0]);

            exit(EXIT_SUCCESS);
        }

        // Reset ist exklusiv und beendet das Programm immer
        if (!strcmp(argv[i], "--reset") || !strcmp(argv[i], "-r")) {
            [Calculator reset];

            exit(EXIT_SUCCESS);
        }

        // Balance ist exklusiv und beendet das Programm immer
        if (!strcmp(argv[i], "--balance") || !strcmp(argv[i], "--list")) {
            NSDictionary *dictionary = [calculator currentSaldo];

            for (id asset in [[dictionary allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)]) {
                NSDictionary *ratings = [calculator checkpointForAsset:asset];

                double initialPrice = [ratings[CP_INITIAL_PRICE] doubleValue];
                double currentPrice = [ratings[CP_CURRENT_PRICE] doubleValue];
                double percent = [ratings[CP_PERCENT] doubleValue];

                printf("%5s: %12s | %11s | %11s | %6s\n",
                    [asset UTF8String],
                    [[NSString stringWithFormat:@"%4.6f", [dictionary[asset] doubleValue]] UTF8String],
                    [[NSString stringWithFormat:@"%4.6f", initialPrice] UTF8String],
                    [[NSString stringWithFormat:@"%4.6f", currentPrice] UTF8String],
                    [[NSString stringWithFormat:@"%3.2f", percent] UTF8String]
                );
            }

            exit(EXIT_SUCCESS);
        }
    }

    for (int i = 1; i < argc; i++) {
        if (!strcmp(argv[i], [[NSString stringWithFormat:@"--%@", ASSET1.lowercaseString] UTF8String])) {
            value = atof(argv[i + 1]);
            [calculator currentSaldo:ASSET1 withDouble:value];
            [calculator updateCheckpointForAsset:ASSET1 withBTCUpdate:false];
            update = true;
        }

        if (!strcmp(argv[i], [[NSString stringWithFormat:@"--%@", ASSET2.lowercaseString] UTF8String])) {
            value = atof(argv[i + 1]);
            [calculator currentSaldo:ASSET2 withDouble:value];
            [calculator updateCheckpointForAsset:ASSET2 withBTCUpdate:false];
            update = true;
        }

        if (!strcmp(argv[i], [[NSString stringWithFormat:@"--%@", ASSET3.lowercaseString] UTF8String])) {
            value = atof(argv[i + 1]);
            [calculator currentSaldo:ASSET3 withDouble:value];
            [calculator updateCheckpointForAsset:ASSET3 withBTCUpdate:false];
            update = true;
        }

        if (!strcmp(argv[i], [[NSString stringWithFormat:@"--%@", ASSET4.lowercaseString] UTF8String])) {
            value = atof(argv[i + 1]);
            [calculator currentSaldo:ASSET4 withDouble:value];
            [calculator updateCheckpointForAsset:ASSET4 withBTCUpdate:false];
            update = true;
        }

        if (!strcmp(argv[i], [[NSString stringWithFormat:@"--%@", ASSET5.lowercaseString] UTF8String])) {
            value = atof(argv[i + 1]);
            [calculator currentSaldo:ASSET5 withDouble:value];
            [calculator updateCheckpointForAsset:ASSET5 withBTCUpdate:false];
            update = true;
        }

        if (!strcmp(argv[i], [[NSString stringWithFormat:@"--%@", ASSET6.lowercaseString] UTF8String])) {
            value = atof(argv[i + 1]);
            [calculator currentSaldo:ASSET6 withDouble:value];
            [calculator updateCheckpointForAsset:ASSET6 withBTCUpdate:false];
            update = true;
        }

        if (!strcmp(argv[i], [[NSString stringWithFormat:@"--%@", ASSET7.lowercaseString] UTF8String])) {
            value = atof(argv[i + 1]);
            [calculator currentSaldo:ASSET7 withDouble:value];
            [calculator updateCheckpointForAsset:ASSET7 withBTCUpdate:false];
            update = true;
        }

        if (!strcmp(argv[i], [[NSString stringWithFormat:@"--%@", ASSET8.lowercaseString] UTF8String])) {
            value = atof(argv[i + 1]);
            [calculator currentSaldo:ASSET8 withDouble:value];
            [calculator updateCheckpointForAsset:ASSET8 withBTCUpdate:false];
            update = true;
        }

        if (!strcmp(argv[i], [[NSString stringWithFormat:@"--%@", ASSET9.lowercaseString] UTF8String])) {
            value = atof(argv[i + 1]);
            [calculator currentSaldo:ASSET9 withDouble:value];
            [calculator updateCheckpointForAsset:ASSET9 withBTCUpdate:false];
            update = true;
        }

        if (!strcmp(argv[i], [[NSString stringWithFormat:@"--%@", ASSET10.lowercaseString] UTF8String])) {
            value = atof(argv[i + 1]);
            [calculator currentSaldo:ASSET10 withDouble:value];
            [calculator updateCheckpointForAsset:ASSET10 withBTCUpdate:false];
            update = true;
        }

        if (!strcmp(argv[i], "--timeout") || !strcmp(argv[i], "-t")) {
            value = atof(argv[i + 1]);
            config->timeout = value;
        }

        if (!strcmp(argv[i], "--rows")) {
            value = atoi(argv[i + 1]);
            config->rows = value;
        }
    }

    if (update) {
        exit(EXIT_SUCCESS);
    }
}

/**
 * Hauptroutine des kleinen, handlichen Tools
 *
 * @param argc
 * @param argv
 * @return
 */
int main(int argc, const char *argv[]) {
    @autoreleasepool {
        CONFIG config = {DEFAULT_TIMEOUT, DEFAULT_ROWS};

        if (argc > 1) {
            parseOptions(argc, argv, &config);
        }

        brokerRun(config);
    }

    return EXIT_SUCCESS;
}
