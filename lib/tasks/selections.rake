require 'porser/cli/actions/selector'
require 'porser/cli/actions/runner'

namespace :selections do
  desc "Create a selection of a corpus splitted in train, dev and test samples"
  task :create do
    corpus_path = Porser.path.join("corpus", "pre-processed")
    file_list   = Components::FileList.new(corpus_path, :title => "Available corpus", :question => "Select the corpus you want to use")
    
    if corpora_path = file_list.ask
      Actions::Selector.run(corpora_path)
    else
      puts "None selected, aborting."
    end
  end
  
  desc "Remove all foders in corpus/selections/"
  task :clear do
    question = Components::Question.new("Are you sure you wanna remove corpus/selections/* ?", :default => "n")

    if question.ask
      selections_path = Porser.path.join("corpus", "selections")
      Dir["#{selections_path}/*"].each { |path| rm_rf(path) }
      puts "Removed."
    else
      puts "Aborted."
    end
  end
  
  desc "Run the training process for the given selection"
  task :train do
    selections_path = Porser.path.join("corpus", "selections")
    file_list       = Components::FileList.new(selections_path, :title => "Available selections", :question => "Choose the selection to train")
    
    if selection_path = file_list.ask
      Actions::Runner.new(selection_path, ENV['HEAP_SIZE'] ? ENV['HEAP_SIZE'].to_i : 700).train!
    else
      puts "None selected, aborting."
    end
  end
end