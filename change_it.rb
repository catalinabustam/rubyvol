class ChangeIt
  def change(path, name)
    FileUtils.cp path, '/Users/catalinabustamante/Desktop/guardadas/' + name
    puts 'holaaaaaaa'
  end
end

