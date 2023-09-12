class Cart

  def initialize
    # @products = [1,2,2,3,4,8,2,9,2,0,3]
    @products = [17,23,29,37]
  end

  def all
    @products
  end

  def order(way, count)
    response = @products
    if (way=='des')
      response = response.sort_by { |e| -e }
    end
    if (way=='asc')
      response = response.sort_by { |e| e }
    end
    if (count!=0)
      response = response.first(count)
    end
    response
  end

  def at(ix)
    @products[ix]
  end

  def add(e)
    @products.push(e)
  end

  def change(ix)
    @products.push(@products.delete_at(ix) + 1)
  end

  def replace(e)
    @products.shift.push(e)
  end

  def remove(e)
    @products.delete(e)
  end

  def total
    @products.reduce(:+)
  end
end
