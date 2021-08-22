class Element
  attr_reader :datum
  attr_accessor :next
  def initialize(datum)
    @datum = datum
    @next = nil
  end
end

class SimpleLinkedList
  def initialize(arr = [])
    init(arr)
  end

  def init(arr = [])
    @head = nil
    arr.each { |x| push(Element.new(x)) }
  end

  def push(element)
     element.next = @head
     @head = element
     self
  end

  def pop()
    save = @head
    if (@head != nil)
      @head = @head.next
    end
    save
  end

  def to_a
    to_a_element.collect{|ele| ele.datum}
  end

  def to_a_element
   arr = []
   current = @head
   while (current != nil)
     arr << current
     current = current.next
   end
   arr
  end

  def reverse!()
    arr = to_a_element
    @head = nil
    arr.each{|ele| push(ele) }
    self
  end
end
