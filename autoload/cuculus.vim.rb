class Cuculus
  def self.silent(&block)
    $stderr = StringIO.new
    block.call
  ensure
    $stderr = STDERR
  end

  def self.pair_range(code:, line:, column:)
    return new.pair_range(code: code, line: line, column: column)
  end

  silent do
    require 'parser/current'
  end
  require 'json'

  def traverse(ast, &block)
    block.call ast
    ast.children.each do |child|
      traverse(child, &block) if child.is_a?(Parser::AST::Node)
    end
  end

  def include_loc?(range:, line:, column:)
    start_line = range.line
    end_line = range.last_line
    start_col = range.column
    end_col = range.last_column

    (start_line < line || (start_line == line && start_col <= column)) &&
      (line < end_line || (line == end_line && column <= end_col))
  end

  def range(node, key)
    node.loc.respond_to?(key) && node.loc.__send__(key)
  end

  def pair_range(code:, line:, column:)
    ast = Parser::CurrentRuby.parse(code)

    traverse(ast) do |node|
      keyword_range = range(node, :keyword) || range(node, :begin)
      next unless keyword_range
      end_range = range(node, :end)
      next unless end_range
      ranges = {
        keyword: keyword_range,
        end: end_range,
      }

      ranges.each do |key, range|
        if include_loc?(range: range, line: line, column: column)
          return ranges[key == :keyword ? :end : :keyword]
        end
      end
    end
  end
end
