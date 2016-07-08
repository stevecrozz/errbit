require 'pry'
require_relative '../lib/doc_builder'
require_relative '../lib/kramdown_monkey_patches'

Jekyll::Hooks.register :site, :after_reset do |post|
  doc_builder = DocBuilder.new('.')
  doc_builder.run
end
