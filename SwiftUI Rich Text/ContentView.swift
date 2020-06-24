import SwiftUI

// MARK: - A basic hardcoded rich text example

struct BasicRichTextView: View {
    var body: some View {
        (
            Text("Bold").bold() +
            Text("ly going").italic() +
            Text(" where new lines have gone").foregroundColor(.red) +
            Text(" before.").font(.headline)
        )
        .padding()
        .frame(maxWidth: 200, maxHeight: 100)
    }
}

// MARK: - Demo of programmatic rich text

enum RichTextBlock: Hashable {
    case plainTextBlock([InlineText])
    case quote([RichTextBlock])
}

struct InlineText: Hashable {
    let text: String
    let attributes: TextAttributes
}

struct TextAttributes: OptionSet, Hashable {
    let rawValue: Int

    static let bold    = TextAttributes(rawValue: 1 << 0)
    static let italic  = TextAttributes(rawValue: 1 << 1)
    static let heading   = TextAttributes(rawValue: 1 << 2)
}

struct ProgrammaticRichTextView: View {
    let topBlocks: [RichTextBlock]
    
    var body: some View {
        VStack {
            ForEach(topBlocks, id: \.self) { block in
                TextBlockView(block: block)
            }
        }
    }
}

struct TextBlockView: View {
    let block: RichTextBlock
    
    var body: some View {
       /* VStack {
            switch block {
            case .plainTextBlock(let text):
                renderInlineText(text)
            case .quote(let quote):
                renderQuote(quote)
            }
        }*/
        Text("Temp")
    }
    
    func renderInlineText(_ text: [InlineText]) -> some View {
        return Text("Inline text")
    }

    func renderQuote(_ quote: [RichTextBlock]) -> some View {
        return Text("Quote text")
    }
}

let demoBlocks: [RichTextBlock] = [
    .plainTextBlock([InlineText(text: "foo", attributes: [.bold])])
]

struct RichTextView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            BasicRichTextView()
            ProgrammaticRichTextView(topBlocks: demoBlocks)
        }
    }
}
