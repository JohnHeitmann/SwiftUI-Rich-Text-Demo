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

/*
 We'll use a model similar to html: blocks stack vertically
 on top of each other, and inline data wraps around
 horizontally.
 
 This makes rendering easy: blocks are arrayed in a VStack,
 while inline values are concatenated with Text() + Text()
 */

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
    static let heading = TextAttributes(rawValue: 1 << 2)
}

struct ProgrammaticRichTextView: View {
    let topBlocks: [RichTextBlock]
    
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(topBlocks, id: \.self) { block in
                TextBlockView(block: block)
            }
        }
    }
}

struct TextBlockView: View {
    let block: RichTextBlock
    
    var body: some View {
        VStack(alignment: .leading) { // Dummy wrapper view to appease the compiler
            switch block {
            case .plainTextBlock(let text):
                renderInlineText(text)
            case .quote(let quote):
                renderQuote(quote)
            }
        }
    }
    
    func renderInlineText(_ text: [InlineText]) -> some View {
        return text.map {t in
            var atomView: Text = Text(t.text)
            if t.attributes.contains(.bold) {
                atomView = atomView.bold()
            }
            if t.attributes.contains(.italic) {
                atomView = atomView.italic()
            }
            if t.attributes.contains(.heading) {
                atomView = atomView.font(.headline)
            }
            return atomView
        }.reduce(Text(""), +)
    }

    func renderQuote(_ quote: [RichTextBlock]) -> some View {
        return VStack(alignment: .leading) {
            ForEach(quote, id: \.self) {q in
                TextBlockView(block: q)
            }
        }
        .padding()
        .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
        .padding()
    }
}

// MARK: -- Preview and demo data

let demoBlocks: [RichTextBlock] = [
    .plainTextBlock([
        InlineText(text: "Quote", attributes: [.heading]),
    ]),
    .quote([
        .plainTextBlock([
            InlineText(text: "There are texts that have ", attributes: []),
            InlineText(text: "style", attributes: [.italic]),
            InlineText(text: " and texts that are ", attributes: []),
            InlineText(text: "rich.", attributes: [.bold]),
        ])
    ]),
    .plainTextBlock([
        InlineText(text: "-- Not Coco Channel", attributes: [.italic]),
    ])
]

struct RichTextView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            BasicRichTextView()
            ProgrammaticRichTextView(topBlocks: demoBlocks)
        }
    }
}
