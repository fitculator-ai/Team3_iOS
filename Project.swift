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
            deploymentTargets: .iOS("17.0"),
            infoPlist: .extendingDefault(
                with: [
                    "NSAppTransportSecurity": [
                        "NSAllowsArbitraryLoads": true
                    ],
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                    "UIUserInterfaceStyle": "Dark",
                    "NSCameraUsageDescription": "사진을 찍기 위해 카메라에 접근해야 합니다.",
                    "NSPhotoLibraryUsageDescription": "사진 라이브러리에 접근해야 합니다."
                ]
            ),
            sources: ["Fitculator/Sources/**"],
            resources: ["Fitculator/Resources/**",
                        "Shared/Localization/en.lproj/Localizable.strings",
                        "Shared/Localization/ko.lproj/Localizable.strings"],
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
            deploymentTargets: .iOS("17.0"),
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
                deploymentTargets: .iOS("17.0"),
                infoPlist: .default,
                sources: ["Features/**"],
                resources: ["Features/**/*.xcassets"],
                dependencies: [
                    .target(name: "Core"),
                    .target(name: "Shared"),
                    .external(name: "Kingfisher"),
                    .external(name: "FSCalendar"),
                ]
            ),
        
            .target(
                name: "Core",
                destinations: [.iPhone, .iPad],
                product: .framework,
                bundleId: "io.fitculator.Fitculator.core",
                deploymentTargets: .iOS("17.0"),
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
                deploymentTargets: .iOS("17.0"),
                infoPlist: .default,
                sources: ["Shared/**"],
                dependencies: [
                    .target(name: "Core")
                ]
            ),
    ]
)
