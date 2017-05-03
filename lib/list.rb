class List
  attr_reader(:name, :id)

  def initialize(attributes)
    @name = attributes.fetch(:name)
    @id = attributes.fetch(:id)
  end

  def List.all
    returned_lists = DB.exec("SELECT * FROM lists;")
    lists = []
    returned_lists.each() do |list|
      name = list.fetch("name")
      id = list.fetch("id").to_i()
      lists.push(List.new({:name => name, :id => id}))
    end
    lists
  end

  def save
    result = DB.exec("INSERT INTO lists (name) VALUES ('#{@name}') RETURNING id;")
    @id = result.first.fetch("id").to_i
  end

  def ==(another_list)
    self.name.==(another_list.name).&(self.id.==(another_list.id))
  end

  def List.find(id)
    List.all.each do |list|
      if list.id == id
        return list
      end
    end
  end

  def tasks
    list_tasks = []
    tasks = DB.exec("SELECT * FROM tasks WHERE list_id = #{self.id};")
    tasks.each do |task|
      description = task.fetch('description')
      list_id = task.fetch('list_id').to_i
      id = task.fetch('id').to_i
      list_tasks.push(Task.new({:description => description, :list_id => list_id, :id => id}))
    end
    list_tasks
  end

  def update (attributes)
   @name = attributes.fetch(:name)
   @id = self.id
   DB.exec("UPDATE lists SET name = '#{@name}' WHERE id = #{@id};")
  end

  def delete
    DB.exec("DELETE FROM lists WHERE id = #{self.id};")
    DB.exec("DELETE FROM tasks WHERE list_id = #{self.id};")
  end
  #
  # def delete_tasks
  #   DB.exec("DELETE FROM tasks WHERE list_id = #{self.id};")
  # end
end
