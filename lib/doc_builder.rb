require 'pathname'
require 'rugged'
require 'fileutils'
require 'oga'

class DocBuilder
  def initialize(path)
    @repo = Rugged::Repository.new(path)
  end

  def release_tags
  end

  def run
    @repo.tags.each do |tag|
      next unless tag.name =~ /^v.+/
      build_tree(tag.target.tree, File.join('docs', tag.name))
    end

    master = @repo.branches['master']
    build_tree(master.target.tree, 'docs')
  end

  def build_tree(tree, path)
    puts "Building docs for path #{path}..."

    tree.walk(:preorder) do |root, entry|
      next unless root =~ /^docs\// || entry[:name] == 'README.md'
      handle_entry(root, entry, path)
    end
  end

  def path_for_node(root, entry, path)
    if root.empty? && entry[:name] == 'README.md'
      File.join(path, 'index.md')
    else
      File.join(path, root.sub(/^docs\//, ''), entry[:name])
    end
  end

  def handle_entry(root, entry, path)
    return unless entry[:type] == :blob

    entry_path = path_for_node(root, entry, path)
    # puts entry_path

    dir = File.dirname(entry_path)
    FileUtils.mkdir_p(dir) unless File.exist?(dir)

    blob = @repo.read(entry[:oid])

    content = blob.data
    content = "---\n---\n" + content if entry_path =~ /\.md$/
    write_file(entry_path, content)
  end

  def write_file(path, content)
    File.write(path, content)
  end
end
