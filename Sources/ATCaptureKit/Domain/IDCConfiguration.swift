import SwiftUI

/// How the capture header above the viewfinder is laid out.
public enum IDCCaptureHeaderStyle {
    /// Icon, title, gradient-highlighted subtitle.
    case standard
    /// Title only, with an optional host view 20pt under it (e.g. KYC v2's "Used by visa agent"
    /// chip) — no icon, no subtitle (Onboarding V2, Figma 1959:177641).
    case titleOnly(accessory: AnyView?)
}

public struct IDCCaptureCopy {
    public var title: String?
    public var subtitle: String?
    public var eyebrow: String?
    public var headerStyle: IDCCaptureHeaderStyle
    /// The prompt on the front→back flip panel (passport back piece only); nil ⇒ the built-in one.
    public var flipHint: String?

    public init(
        title: String? = nil,
        subtitle: String? = nil,
        eyebrow: String? = nil,
        headerStyle: IDCCaptureHeaderStyle = .standard,
        flipHint: String? = nil
    ) {
        self.title = title
        self.subtitle = subtitle
        self.eyebrow = eyebrow
        self.headerStyle = headerStyle
        self.flipHint = flipHint
    }
}

/// A host-owned link under the capture controls (KYC v2's served fallback, e.g. "Don't have it
/// handy?"). Shown from the start in place of the built-in reminder link; the host handles the tap.
public struct IDCFallbackLink {
    public let title: String
    public let onTap: () -> Void

    public init(title: String, onTap: @escaping () -> Void) {
        self.title = title
        self.onTap = onTap
    }
}

public enum IDCProgressStyle: Equatable {
    /// Piece-driven: `filled` is recomputed from the capture's own pieces (`displayProgress`).
    case segments(count: Int, filled: Int)
    /// Host-driven steps, drawn exactly as given — the flow around the capture owns the position
    /// (KYC onboarding v2's 6-step bar).
    case steps(count: Int, filled: Int)
    case fraction(Double)
    case hidden
}

public struct IDCSkipOption {
    public var title: String
    public var appearsAfter: TimeInterval
    public var appearsAfterRejections: Int

    public init(
        title: String = IDCStrings.CTA.skip,
        appearsAfter: TimeInterval = 10,
        appearsAfterRejections: Int = 2
    ) {
        self.title = title
        self.appearsAfter = appearsAfter
        self.appearsAfterRejections = appearsAfterRejections
    }
}

public enum IDCScanTopBarPlacement {
    case standard
    case embeddedSheet
}

public struct IDCConfiguration {
    var pieces: [IDCPiece]
    var flowTitle: String?
    var resolvedFlowTitle: String { flowTitle ?? IDCStrings.Flow.defaultTitle }
    public var copy: [IDCPiece: IDCCaptureCopy] = [:]
    public var progress: IDCProgressStyle = .segments(count: 4, filled: 1)
    public var showsBack: Bool = true
    public var allowUploadFromDevice: Bool = true
    public var showsScanTopBar: Bool = true
    public var scanTopBarPlacement: IDCScanTopBarPlacement = .standard
    public var scanTopBarTrailingSystemImage: String?
    public var onScanTopBarTrailingTap: (() -> Void)?
    public var headerAccessory: AnyView?
    public var showsReminderLink: Bool = true
    public var fallbackLink: IDCFallbackLink?
    public var skip: IDCSkipOption?
    public var analyticsSubjectId: String?
    var reminderLinkRevealNanoseconds: UInt64 = IDCTheme.Animation.reminderLinkRevealNanoseconds
    public var onReminderSet: ((Date) -> Void)?
    public var selfieSubjectName: String?
    public var passportChecks = IDCPassportChecks()
    public var selfieChecks = IDCSelfieChecks.standard
    public var selfieUploadChecks: IDCSelfieChecks?
    let analyticsContext: String
    #if DEBUG
    var debugSimulateCameraDenied: Bool = false
    var debugSimulateCameraPrimer: Bool = false
    var debugRevealsReminderLinkImmediately: Bool = false
    #endif

    public init(pieces: [IDCPiece], flowTitle: String? = nil, analyticsContext: String) {
        self.pieces = pieces
        self.flowTitle = flowTitle
        self.analyticsContext = analyticsContext
    }

    func copy(for piece: IDCPiece) -> IDCCaptureCopy {
        copy[piece] ?? IDCCaptureCopy()
    }

    var scanTopBarBaseTopPadding: CGFloat {
        switch scanTopBarPlacement {
        case .standard:
            return IDCTheme.Layout.topBarTopPadding
        case .embeddedSheet:
            return IDCTheme.Layout.embeddedSheetTopBarTopPadding
        }
    }

    var scanTopBarIncludesSafeAreaTop: Bool {
        scanTopBarPlacement == .embeddedSheet
    }

    var isCompactHost: Bool {
        scanTopBarPlacement == .embeddedSheet
    }

    var headerTopPadding: CGFloat {
        isCompactHost ? IDCTheme.Layout.compactHeaderTopPadding : IDCTheme.Layout.headerTopPadding
    }

    var viewfinderTopPadding: CGFloat {
        isCompactHost ? IDCTheme.Layout.compactViewfinderTopPadding : IDCTheme.Layout.viewfinderTopPadding
    }

    var selfieScannerTopPadding: CGFloat {
        isCompactHost ? IDCTheme.Layout.compactSelfieScannerTopPadding : IDCTheme.Layout.selfieScannerTopPadding
    }

    var footerMinHeight: CGFloat {
        isCompactHost ? IDCTheme.Layout.compactFooterMinHeight : IDCTheme.Layout.footerMinHeight
    }
}
