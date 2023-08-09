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

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  def build_tree(array = @nodelist)
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
    current_node = Node.new(array[middle])
    current_node.left = build_nodes(array, first, middle - 1)
    current_node.right = build_nodes(array, middle + 1, last)

    return current_node
  end

  def insert(value, current_node = nil)
    if current_node == nil
      current_node = @root
    end

    if current_node.data == value
      puts "#{value} already exists in tree."
      return
    end

    if current_node.data < value
      if current_node.right.nil?
        current_node.right = Node.new(value)
        puts "#{value} added to tree."
        return current_node.right
      else
        insert(value, current_node.right)
      end
    else
      if current_node.left.nil?
        current_node.left = Node.new(value)
        puts "#{value} added to tree."
        return current_node.left
      else
        insert(value, current_node.left)
      end
    end
  end

  def delete(value, current_node = @root)

    if current_node.data < value
      current_node.right = delete(value, current_node.right)
      return current_node
    elsif current_node.data > value
      current_node.left = delete(value, current_node.left)
      return current_node
    end

    if current_node.left.nil?
      return current_node.right
    elsif current_node.right.nil?
      return current_node.left
    end

    target_node = current_node
    replacement_node = current_node.right

    until replacement_node.left.nil?
      target_node = current_node.right
      replacement_node = replacement_node.left
    end

    unless target_node == current_node
      target_node.left = replacement_node.right
    else
      target_node.right = replacement_node.right
    end

    current_node.data = replacement_node.data

    return current_node
  end

  def find(value, current_node = @root)
    if current_node.data == value
      return current_node
    elsif current_node.right.nil?.! && current_node.data < value
      return find(value, current_node.right)
    elsif current_node.left.nil?.! && current_node.data > value
      return find(value, current_node.left)
    end

    puts "#{value} not found in tree."
  end

  def level_order()
    queue = [@root]
    values = []
    current_node = @root

    until queue.empty?
      current_node = queue.first
      if block_given?
        yield(current_node)
      end

      values.push(current_node.data)

      unless current_node.left.nil?
        queue.push(current_node.left)
      end

      unless current_node.right.nil?
        queue.push(current_node.right)
      end

      queue.shift
    end

    unless block_given?
      return values
    end
  end

  def inorder(current_node = @root, values = [], &block)
    return if current_node.nil?

    inorder(current_node.left, values, &block)
    yield(current_node) if block_given?
    values.push(current_node.data)
    inorder(current_node.right, values, &block)

    return values unless block_given?
  end

  def preorder(current_node = @root, values = [], &block)
    return if current_node.nil?

    yield(current_node) if block_given?
    values.push(current_node.data)
    preorder(current_node.left, values, &block)
    preorder(current_node.right, values, &block)

    return values unless block_given?
  end

  def postorder(current_node = @root, values = [], &block)
    return if current_node.nil?

    postorder(current_node.left, values, &block)
    postorder(current_node.right, values, &block)
    yield(current_node) if block_given?
    values.push(current_node.data)

    return values unless block_given?
  end

  def height(current_node = @root, node_count = 0)
    unless current_node.nil?
      node_count += 1
    end

    if current_node.left.nil? && current_node.right.nil?
      return node_count
    end

    left = 0
    right = 0

    unless current_node.left.nil?
      left += height(current_node.left, node_count)
    end
    
    unless current_node.right.nil?
      right += height(current_node.right, node_count)
    end

    left > right ? left : right
  end

  def depth(given_node = @root, current_node = @root, node_count = 0)
    node_count += 1

    if given_node.data == current_node.data
      return node_count
    elsif given_node.data < current_node.data
      return depth(given_node, current_node.left, node_count)
    else
      return depth(given_node, current_node.right, node_count)
    end
      
  end

  def balanced?(root_node = @root)
    if (height(root_node.left) - height(root_node.right) >= -1) &&
      (height(root_node.left) - height(root_node.right) <= 1)
      return true
    end
    return false
  end

  def rebalance(root_node = @root)
    if balanced?(root_node)
      puts "The tree is already balanced."
      return
    end

    node_array = inorder(root_node)
    build_tree(node_array)

    puts "Tree successfully rebalanced!"
  end

end

my_tree = Tree.new([8,7,14,3,8,1,13,2,4,9,10,12,5,15,10,6,11,3])
my_tree.pretty_print
puts "Balanced tree: #{my_tree.balanced?}"
my_tree.insert(16)
my_tree.insert(17)
my_tree.insert(18)
my_tree.insert(19)
my_tree.insert(20)
my_tree.insert(21)
my_tree.pretty_print
puts "Balanced tree: #{my_tree.balanced?}"
my_tree.rebalance
my_tree.pretty_print
puts "Balanced tree: #{my_tree.balanced?}"