module Porser
  module Filters
    class RemoveConjSubcategories
      def run(sentence)
        Corpus::Sentence.new(map(sentence.root_node))
      end
      
    protected
      def map(node)
        tag = (node.tag =~ /^CONJ_/ ? "CONJ" : node.tag)
        
        case node
        when Corpus::Category
          Corpus::Category.new(tag, node.children.map { |child| map(child) })
        when Corpus::PartOfSpeech
          Corpus::PartOfSpeech.new(tag, node.word, node.extra)
        end
      end
    end
  end
end