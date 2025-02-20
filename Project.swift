import ProjectDescription

let project = Project(
    name: "Fitculator",
    options: .options(
        automaticSchemesOptions: .disabled,
        defaultKnownRegions: ["en", "ko"],
        developmentRegion: "ko",
        textSettings: .textSettings(usesTabs: false, indentWidth: 4, tabWidth: 4)
    ),
    targets: [
        .target(
            name: "Fitculator",
            destinations: [.iPhone, .iPad],
            product: .app,
            bundleId: "io.fitculator.Fitculator",
            deploymentTargets: .iOS("16.6"),
            infoPlist: .extendingDefault(
                with: [
                    "NSAppTransportSecurity": [
                        "NSAllowsArbitraryLoads": true
                    ],
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                    "UIUserInterfaceStyle": "Dark"
                ]
            ),
            sources: ["Fitculator/Sources/**"],
            resources: ["Fitculator/Resources/**"],
            dependencies: [
                .target(name: "Features"),
                .target(name: "Core"),
                .target(name: "Shared")
            ]
        ),
        .target(
            name: "FitculatorTests",
            destinations: [.iPhone, .iPad],
            product: .unitTests,
            bundleId: "io.fitculator.FitculatorTests",
            deploymentTargets: .iOS("16.6"),
            infoPlist: .default,
            sources: ["Fitculator/Tests/**"],
            resources: [],
            dependencies: [.target(name: "Fitculator")]
        ),
        
            .target(
                name: "Features",
                destinations: [.iPhone, .iPad],
                product: .framework,
                bundleId: "io.fitculator.Fitculator.features",
                deploymentTargets: .iOS("16.6"),
                infoPlist: .default,
                sources: ["Features/**"],
                dependencies: [
                    .target(name: "Core"),
                    .target(name: "Shared"),
                    .external(name: "Kingfisher")
                ]
            ),
        
            .target(
                name: "Core",
                destinations: [.iPhone, .iPad],
                product: .framework,
                bundleId: "io.fitculator.Fitculator.core",
                deploymentTargets: .iOS("16.6"),
                infoPlist: .default,
                sources: ["Core/**"],
                dependencies: [
                    .external(name: "Alamofire")
                ]
            ),
        
            .target(
                name: "Shared",
                destinations: [.iPhone, .iPad],
                product: .framework,
                bundleId: "io.fitculator.Fitculator.shared",
                deploymentTargets: .iOS("16.6"),
                infoPlist: .default,
                sources: ["Shared/**"],
                dependencies: [
                    .target(name: "Core")
                ]
            ),
    ]
)
