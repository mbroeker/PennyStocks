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
const char *makeString(NSDictionary *checkpoint, NSString *asset, NSDictionary *currentRatings, double asset1Percent) {
    double effectivePercent = [checkpoint[CP_PERCENT] doubleValue];
    if (![asset isEqualToString:ASSET_KEY(1)]) effectivePercent -= asset1Percent;

    double currentPrice = [checkpoint[CP_CURRENT_PRICE] doubleValue];
    double currentPriceInBTC = [currentRatings[ASSET_KEY(1)] doubleValue] / [currentRatings[asset] doubleValue];

    NSString *theString = [
        NSString stringWithFormat:@"%.6f EUR / %.8f %@ / %+.2f%%",
            currentPrice,
            currentPriceInBTC,
            ASSET_KEY(1),
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

        NSDictionary *asset1Checkpoint = [calculator checkpointForAsset:ASSET_KEY(1)];
        NSDictionary *asset2Checkpoint = [calculator checkpointForAsset:ASSET_KEY(2)];
        NSDictionary *asset3Checkpoint = [calculator checkpointForAsset:ASSET_KEY(3)];
        NSDictionary *asset4Checkpoint = [calculator checkpointForAsset:ASSET_KEY(4)];
        NSDictionary *asset5Checkpoint = [calculator checkpointForAsset:ASSET_KEY(5)];

        double asset1Percent = [asset1Checkpoint[CP_PERCENT] doubleValue];

        if ((counter++ % config.rows) == 0) {
            printf("%%: %-43s | %-43s | %-43s | %-43s | %-43s\n",
                makeHeadlineString(asset1Checkpoint, ASSET_KEY(1)),
                makeHeadlineString(asset2Checkpoint, ASSET_KEY(2)),
                makeHeadlineString(asset3Checkpoint, ASSET_KEY(3)),
                makeHeadlineString(asset4Checkpoint, ASSET_KEY(4)),
                makeHeadlineString(asset5Checkpoint, ASSET_KEY(5))
            );
        }

        printf("%%: %-43s | %-43s | %-43s | %-43s | %-43s\n",
            makeString(asset1Checkpoint, ASSET_KEY(1), currentRatings, asset1Percent),
            makeString(asset2Checkpoint, ASSET_KEY(2), currentRatings, asset1Percent),
            makeString(asset3Checkpoint, ASSET_KEY(3), currentRatings, asset1Percent),
            makeString(asset4Checkpoint, ASSET_KEY(4), currentRatings, asset1Percent),
            makeString(asset5Checkpoint, ASSET_KEY(5), currentRatings, asset1Percent)
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

    printf("  --%s ANZAHL\t\tSetze den aktuellen Saldo für %s\n", [[NSString stringWithFormat:@"%@", ASSET_KEY(1).lowercaseString] UTF8String], ASSET_DESC(1).UTF8String);
    printf("  --%s ANZAHL\t\tSetze den aktuellen Saldo für %s\n", [[NSString stringWithFormat:@"%@", ASSET_KEY(2).lowercaseString] UTF8String], ASSET_DESC(2).UTF8String);
    printf("  --%s ANZAHL\t\tSetze den aktuellen Saldo für %s\n", [[NSString stringWithFormat:@"%@", ASSET_KEY(3).lowercaseString] UTF8String], ASSET_DESC(3).UTF8String);
    printf("  --%s ANZAHL\t\tSetze den aktuellen Saldo für %s\n", [[NSString stringWithFormat:@"%@", ASSET_KEY(4).lowercaseString] UTF8String], ASSET_DESC(4).UTF8String);
    printf("  --%s ANZAHL\t\tSetze den aktuellen Saldo für %s\n", [[NSString stringWithFormat:@"%@", ASSET_KEY(5).lowercaseString] UTF8String], ASSET_DESC(5).UTF8String);

    printf("  --%s ANZAHL\t\tSetze den aktuellen Saldo für %s\n", [[NSString stringWithFormat:@"%@", ASSET_KEY(6).lowercaseString] UTF8String], ASSET_DESC(6).UTF8String);
    printf("  --%s ANZAHL\t\tSetze den aktuellen Saldo für %s\n", [[NSString stringWithFormat:@"%@", ASSET_KEY(7).lowercaseString] UTF8String], ASSET_DESC(7).UTF8String);
    printf("  --%s ANZAHL\t\tSetze den aktuellen Saldo für %s\n", [[NSString stringWithFormat:@"%@", ASSET_KEY(8).lowercaseString] UTF8String], ASSET_DESC(8).UTF8String);
    printf("  --%s ANZAHL\t\tSetze den aktuellen Saldo für %s\n", [[NSString stringWithFormat:@"%@", ASSET_KEY(9).lowercaseString] UTF8String], ASSET_DESC(9).UTF8String);
    printf("  --%s ANZAHL\t\tSetze den aktuellen Saldo für %s\n", [[NSString stringWithFormat:@"%@", ASSET_KEY(10).lowercaseString] UTF8String], ASSET_DESC(10).UTF8String);

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
        if (!strcmp(argv[i], [[NSString stringWithFormat:@"--%@", ASSET_KEY(1).lowercaseString] UTF8String])) {
            value = atof(argv[i + 1]);
            [calculator currentSaldo:ASSET_KEY(1) withDouble:value];
            [calculator updateCheckpointForAsset:ASSET_KEY(1) withBTCUpdate:false];
            update = true;
        }

        if (!strcmp(argv[i], [[NSString stringWithFormat:@"--%@", ASSET_KEY(2).lowercaseString] UTF8String])) {
            value = atof(argv[i + 1]);
            [calculator currentSaldo:ASSET_KEY(2) withDouble:value];
            [calculator updateCheckpointForAsset:ASSET_KEY(2) withBTCUpdate:false];
            update = true;
        }

        if (!strcmp(argv[i], [[NSString stringWithFormat:@"--%@", ASSET_KEY(3).lowercaseString] UTF8String])) {
            value = atof(argv[i + 1]);
            [calculator currentSaldo:ASSET_KEY(3) withDouble:value];
            [calculator updateCheckpointForAsset:ASSET_KEY(3) withBTCUpdate:false];
            update = true;
        }

        if (!strcmp(argv[i], [[NSString stringWithFormat:@"--%@", ASSET_KEY(4).lowercaseString] UTF8String])) {
            value = atof(argv[i + 1]);
            [calculator currentSaldo:ASSET_KEY(4) withDouble:value];
            [calculator updateCheckpointForAsset:ASSET_KEY(4) withBTCUpdate:false];
            update = true;
        }

        if (!strcmp(argv[i], [[NSString stringWithFormat:@"--%@", ASSET_KEY(5).lowercaseString] UTF8String])) {
            value = atof(argv[i + 1]);
            [calculator currentSaldo:ASSET_KEY(5) withDouble:value];
            [calculator updateCheckpointForAsset:ASSET_KEY(5) withBTCUpdate:false];
            update = true;
        }

        if (!strcmp(argv[i], [[NSString stringWithFormat:@"--%@", ASSET_KEY(6).lowercaseString] UTF8String])) {
            value = atof(argv[i + 1]);
            [calculator currentSaldo:ASSET_KEY(6) withDouble:value];
            [calculator updateCheckpointForAsset:ASSET_KEY(6) withBTCUpdate:false];
            update = true;
        }

        if (!strcmp(argv[i], [[NSString stringWithFormat:@"--%@", ASSET_KEY(7).lowercaseString] UTF8String])) {
            value = atof(argv[i + 1]);
            [calculator currentSaldo:ASSET_KEY(7) withDouble:value];
            [calculator updateCheckpointForAsset:ASSET_KEY(7) withBTCUpdate:false];
            update = true;
        }

        if (!strcmp(argv[i], [[NSString stringWithFormat:@"--%@", ASSET_KEY(8).lowercaseString] UTF8String])) {
            value = atof(argv[i + 1]);
            [calculator currentSaldo:ASSET_KEY(8) withDouble:value];
            [calculator updateCheckpointForAsset:ASSET_KEY(8) withBTCUpdate:false];
            update = true;
        }

        if (!strcmp(argv[i], [[NSString stringWithFormat:@"--%@", ASSET_KEY(9).lowercaseString] UTF8String])) {
            value = atof(argv[i + 1]);
            [calculator currentSaldo:ASSET_KEY(9) withDouble:value];
            [calculator updateCheckpointForAsset:ASSET_KEY(9) withBTCUpdate:false];
            update = true;
        }

        if (!strcmp(argv[i], [[NSString stringWithFormat:@"--%@", ASSET_KEY(10).lowercaseString] UTF8String])) {
            value = atof(argv[i + 1]);
            [calculator currentSaldo:ASSET_KEY(10) withDouble:value];
            [calculator updateCheckpointForAsset:ASSET_KEY(10) withBTCUpdate:false];
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
