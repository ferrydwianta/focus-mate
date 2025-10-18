import SwiftUI

struct NotificationPermissionView: View {
    @Environment(\.dismiss) private var dismiss
    var openSettingsAction: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 12) {
                Image(systemName: "bell.badge")
                    .font(.system(size: 28, weight: .semibold))
                    .foregroundStyle(.tint)
                VStack(alignment: .leading, spacing: 4) {
                    Text("Enable Notifications")
                        .font(.title2).bold()
                    Text("FocusMate uses notifications to keep you informed when focus starts and ends.")
                        .foregroundStyle(.secondary)
                }
            }

            HStack(spacing: 8) {
                Spacer()
                Button("Open Settings") {
                    dismiss()
                    openSettingsAction()
                }
                Button("Not Now") {
                    dismiss()
                }
            }
        }
        .padding()
    }
}

#Preview {
    NotificationPermissionView(openSettingsAction: {})
}
