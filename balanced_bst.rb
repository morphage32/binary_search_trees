class Node
  attr_accessor :data, :left, :right
  def initialize(data)
    @data = data
    @left
    @right
  end

end

class Tree
  attr_reader :root
  def initialize(array = [])
    @nodelist = array
    @root

    build_tree(@nodelist)
  end

  def build_tree(array = @nodelist)
    # sort array and remove duplicates
    array = sort_nodelist(array)
    @root = build_nodes(array, 0, array.length - 1)

    return @root
  end

  def sort_nodelist(array)
    if array.length == 1
      return array
    end

    middle = array.length/2
    left = sort_nodelist(array[0...middle])
    right = sort_nodelist(array[middle...array.length])
    sorted = []

    i = 0
    j = 0

    while i < left.length || j < right.length
      if i == left.length
        sorted.push(right[j])
        j += 1
      elsif j == right.length
        sorted.push(left[i])
        i += 1
      elsif left[i] == right[j]
        j += 1
      elsif left[i] > right[j]
        sorted.push(right[j])
        j += 1
      else
        sorted.push(left[i])
        i += 1
      end
    end

    return sorted
  end

  def build_nodes(array, first, last)
    if first > last
      return nil
    end

    middle = (first + last) / 2
    root_node = Node.new(array[middle])
    root_node.left = build_nodes(array, first, middle - 1)
    root_node.right = build_nodes(array, middle + 1, last)

    return root_node
  end
end

my_tree = Tree.new([1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324])
puts my_tree.root.data