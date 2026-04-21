import SwiftUI

struct ChatView: View {
    @StateObject private var engine = ChatEngine()
    @State private var inputText: String = ""
    @State private var scrollProxy: ScrollViewProxy? = nil
    @FocusState private var inputFocused: Bool

    var body: some View {
        ZStack {
            // Background
            Color(hex: "0A0A0F").ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                header

                Divider().background(Color.white.opacity(0.06))

                // Messages
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 12) {
                            ForEach(engine.messages) { msg in
                                MessageBubble(message: msg)
                                    .id(msg.id)
                            }

                            if engine.isTyping {
                                TypingIndicator()
                                    .id("typing")
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                    }
                    .onChange(of: engine.messages.count) { _ in
                        scrollToBottom(proxy: proxy)
                    }
                    .onChange(of: engine.isTyping) { _ in
                        scrollToBottom(proxy: proxy)
                    }
                    .onAppear {
                        scrollProxy = proxy
                    }
                }

                // Quick Replies
                if !engine.quickReplies.isEmpty {
                    quickRepliesBar
                }

                Divider().background(Color.white.opacity(0.06))

                // Input
                inputBar
            }
        }
        .frame(minWidth: 600, minHeight: 500)
        .onAppear { inputFocused = true }
        .onChange(of: engine.messages.count) { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                inputFocused = true
            }
        }
    }

    // MARK: - Header

    var header: some View {
        HStack(spacing: 12) {
            Text("⚡")
                .font(.system(size: 20))

            Text("Configurator")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)

            Spacer()

            // Status dot
            HStack(spacing: 6) {
                Circle()
                    .fill(Color(hex: "34C759"))
                    .frame(width: 7, height: 7)
                Text("AI Ready")
                    .font(.system(size: 11))
                    .foregroundColor(.white.opacity(0.4))
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
        .background(Color(hex: "0D0D14"))
    }

    // MARK: - Quick Replies Bar

    var quickRepliesBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(engine.quickReplies) { reply in
                    Button {
                        engine.selectQuickReply(reply)
                    } label: {
                        Text(reply.label)
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(.white.opacity(0.85))
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .background(Color(hex: "1E1E2E"))
                            .cornerRadius(20)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color(hex: "6366F1").opacity(0.4), lineWidth: 1)
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
        }
        .background(Color(hex: "0D0D14"))
    }

    // MARK: - Input Bar

    var inputBar: some View {
        HStack(spacing: 12) {
            TextField(engine.inputPlaceholder, text: $inputText)
                .textFieldStyle(.plain)
                .font(.system(size: 14))
                .foregroundColor(.white)
                .focused($inputFocused)
                .onSubmit { sendMessage() }

            Button(action: sendMessage) {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.system(size: 28))
                    .foregroundColor(inputText.trimmingCharacters(in: .whitespaces).isEmpty
                        ? Color.white.opacity(0.15)
                        : Color(red: 168/255, green: 85/255, blue: 247/255)
                    )
            }
            .buttonStyle(.plain)
            .disabled(inputText.trimmingCharacters(in: .whitespaces).isEmpty)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
        .background(Color(red: 13/255, green: 13/255, blue: 20/255))
    }

    // MARK: - Actions

    func sendMessage() {
        let text = inputText.trimmingCharacters(in: .whitespaces)
        guard !text.isEmpty else { return }
        inputText = ""
        engine.send(text)
    }

    func scrollToBottom(proxy: ScrollViewProxy) {
        withAnimation(.easeOut(duration: 0.2)) {
            if engine.isTyping {
                proxy.scrollTo("typing", anchor: .bottom)
            } else if let last = engine.messages.last {
                proxy.scrollTo(last.id, anchor: .bottom)
            }
        }
    }
}

// MARK: - Message Bubble

struct MessageBubble: View {
    let message: ChatMessage

    var body: some View {
        switch message.role {
        case .bot:
            HStack(alignment: .top, spacing: 10) {
                // Bot avatar
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color(hex: "A855F7"), Color(hex: "6366F1")],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 30, height: 30)
                    Text("⚡")
                        .font(.system(size: 13))
                }

                MarkdownText(message.text)
                    .padding(14)
                    .background(Color(hex: "1A1A2E"))
                    .cornerRadius(16)
                    .cornerRadius(4, corners: .topLeft)

                Spacer(minLength: 60)
            }

        case .user:
            HStack(alignment: .top, spacing: 10) {
                Spacer(minLength: 60)

                Text(message.text)
                    .font(.system(size: 14))
                    .foregroundColor(.white)
                    .padding(14)
                    .background(
                        LinearGradient(
                            colors: [Color(hex: "A855F7").opacity(0.7), Color(hex: "6366F1").opacity(0.7)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .cornerRadius(16)
                    .cornerRadius(4, corners: .topRight)
            }

        case .log:
            HStack(alignment: .top, spacing: 10) {
                // Log indent
                Rectangle()
                    .fill(Color(hex: "6366F1").opacity(0.4))
                    .frame(width: 2)
                    .padding(.leading, 40)

                Text(message.text)
                    .font(.system(size: 11, design: .monospaced))
                    .foregroundColor(Color(hex: "A8FF78"))
                    .frame(maxWidth: .infinity, alignment: .leading)

                Spacer(minLength: 20)
            }

        case .system:
            Text(message.text)
                .font(.system(size: 11))
                .foregroundColor(.white.opacity(0.3))
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.vertical, 4)
        }
    }
}

// MARK: - Typing Indicator

struct TypingIndicator: View {
    @State private var animate = false

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color(hex: "A855F7"), Color(hex: "6366F1")],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 30, height: 30)
                Text("⚡").font(.system(size: 13))
            }

            HStack(spacing: 5) {
                ForEach(0..<3, id: \.self) { i in
                    Circle()
                        .fill(Color.white.opacity(0.4))
                        .frame(width: 7, height: 7)
                        .offset(y: animate ? -4 : 0)
                        .animation(
                            .easeInOut(duration: 0.5)
                                .repeatForever()
                                .delay(Double(i) * 0.15),
                            value: animate
                        )
                }
            }
            .padding(14)
            .background(Color(hex: "1A1A2E"))
            .cornerRadius(16)

            Spacer()
        }
        .onAppear { animate = true }
    }
}

// MARK: - Markdown Text (simple)

struct MarkdownText: View {
    let raw: String

    init(_ text: String) { self.raw = text }

    var body: some View {
        // Simple markdown: **bold**, `code`, newlines
        Text(attributed)
            .font(.system(size: 14))
            .foregroundColor(.white.opacity(0.9))
            .textSelection(.enabled)
            .fixedSize(horizontal: false, vertical: true)
    }

    var attributed: AttributedString {
        (try? AttributedString(markdown: raw))
        ?? AttributedString(raw)
    }
}

// MARK: - Corner Radius helper

extension View {
    func cornerRadius(_ radius: CGFloat, corners: RectCorner) -> some View {
        clipShape(RoundedCornerShape(radius: radius, corners: corners))
    }
}

enum RectCorner {
    case topLeft, topRight, bottomLeft, bottomRight
}

struct RoundedCornerShape: Shape {
    var radius: CGFloat
    var corners: RectCorner

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let tl = corners == .topLeft ? radius : 0
        let tr = corners == .topRight ? radius : 0
        path.move(to: CGPoint(x: rect.minX + tl, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX - tr, y: rect.minY))
        if tr > 0 { path.addArc(center: CGPoint(x: rect.maxX - tr, y: rect.minY + tr), radius: tr, startAngle: .degrees(-90), endAngle: .degrees(0), clockwise: false) }
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        if tl > 0 { path.addArc(center: CGPoint(x: rect.minX + tl, y: rect.minY + tl), radius: tl, startAngle: .degrees(180), endAngle: .degrees(-90), clockwise: false) }
        path.closeSubpath()
        return path
    }
}
