public struct IDCPassportChecks: Equatable, Sendable {
    public var glare: Bool
    public var fingers: Bool
    /// The on-device blur classifier on the detected page (`passport_blur_model`). Runs on the same
    /// crop the glare check reads, for both pages, and is skipped on a frame that already failed
    /// fingers or glare.
    public var blur: Bool

    public init(glare: Bool = true, fingers: Bool = true, blur: Bool = true) {
        self.glare = glare
        self.fingers = fingers
        self.blur = blur
    }
}

public struct IDCSelfieChecks: Equatable, Sendable {
    public var closedEyes: Bool
    public var coveredFace: Bool
    public var glasses: Bool
    public var faceInCenter: Bool
    public var faceStraight: Bool
    public var smile: Bool
    public var tooClose: Bool

    public init(
        closedEyes: Bool,
        coveredFace: Bool,
        glasses: Bool,
        faceInCenter: Bool,
        faceStraight: Bool,
        smile: Bool,
        tooClose: Bool
    ) {
        self.closedEyes = closedEyes
        self.coveredFace = coveredFace
        self.glasses = glasses
        self.faceInCenter = faceInCenter
        self.faceStraight = faceStraight
        self.smile = smile
        self.tooClose = tooClose
    }

    public static let standard = IDCSelfieChecks(
        closedEyes: true,
        coveredFace: true,
        glasses: true,
        faceInCenter: true,
        faceStraight: false,
        smile: true,
        tooClose: true
    )

    public static let none = IDCSelfieChecks(
        closedEyes: false,
        coveredFace: false,
        glasses: false,
        faceInCenter: false,
        faceStraight: false,
        smile: false,
        tooClose: false
    )
}
