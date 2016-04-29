require 'tk'
require 'tkextlib/tile'
require 'json'
require_relative 'kbgui/kbmodule'
require_relative 'kbgui/kbgame'
require_relative 'kbgui/kbquick_game'

class User 

  include Layout

  def initialize
    @@users.bind("<ComboboxSelected>") {signed_user}
    @@log.bind("Return") {insert_name}
		
    @@button.state ('disabled')
    @@f.state ('disabled')
    @@entry.state ('disabled')
    @@answer.state ('disabled')
    @@info.state ('disabled')
    @@arrayb.each {|x| x.state ('disabled')}
		
    @@users.state ('disabled')
    @@log.state ('disabled')
			
    start_quick_game = proc{quick_game}
    log_in_button = proc{log_in}
    sign_up_button = proc{sign_up}
    clear_users = proc{clear}
		
    @@sel_user['command'] = log_in_button
    @@log_in['command'] = sign_up_button
    @@quick_game['command'] = start_quick_game
    @@reset_users['command'] = clear_users
		
    his = proc{scores}
    @@high_score['command'] = his

    @click = 0
    rules = proc{game_rules}
    @@game_rules['command'] = rules
  end
	
  def display_scores

    @@arrayb.each {|x| x['style'] = 'Normal.TButton'}
    @@info.state ('normal')
    level = @@gamenum
		
    if level < 1 || level > 10
      @@info.delete(1.0, 'end') #deletes everything in the text 
      @@info.insert(1.0, "Select a level from 1 - 10")
      @@f.focus
      @@gamenum.value = ""
    else			
      json = File.read(@@json[@@gamenum - 1])
      scores = JSON.parse(json)
			
      if scores.empty?
        @@info.delete(1.0, 'end') #deletes everything in the text 
				@@info.insert(1.0, "No high scores yet for level #{level}")
      else
				@@info.delete(1.0, 'end') #deletes everything in the text 
				@@info.insert(1.0, "\tHigh Scores for level #{level}:\n\n")
				scores = scores.sort {|a1,a2| a2[1]<=>a1[1]}
				scores.each do |name, score| 
	  			@@info.insert(3.0, "#{name} has solved it in #{score} steps\n")
				end
      end
			@@info.state ('disabled')
			@@f.focus
			@@gamenum.value = ""
    end
  end
	
  def scores
    @@selection.value = "Select a level to see high scores"
    @@entry.state ('disabled')
    @@text.value = ""
    @@arrayb.each {|x| x.state ('disabled')}
    @@arrayb.each {|x| x['style'] = 'Normal.TButton'}
      if @click == 1
				@@info.raise
				@click -= 1
				@@inst_resume.value = 'Instructions'#Resume button becomes 'Instructions' button again
      end
	  @@info.state ('normal')
		@@info.delete(1.0, 'end') #deletes everything in the text 
		@@info.insert(1.0, "Select a level to see high scores")
		
		@@f.state ('!disabled')
		@@f.focus
		@@gamenum.value = ""
		@@button.state ('!disabled')
		@@answer.state ('disabled')
		@@start.value = 'Display'
		
		show = proc{display_scores}
		@@button['command'] = show
		@@f.bind("Return") {display_scores}
	end
	
	def saved_game

	  @@arrayb.each {|x| x['style'] = 'Normal.TButton'}
		@@gamenum.value = ""
		@@f.state ('!disabled')
		@@users.state ('disabled')
		@@name.value = ""
		@@log.state ('disabled')
		
	end
	
	def signed_user

		if @click == 1
		  @@info.raise
			@click -= 1
			@@inst_resume.value = 'Instructions'#Resume button becomes 'Instructions' button again
		end
		@@button.state ('!disabled')
		new_name = @@name.value
		
		@@info.state ('normal')
		@@info.delete(1.0, 'end') #deletes everything in the text 
		@@info.insert(1.0, "Welcome #{new_name}. Start playing the game")
		@@info.state ('disabled')
		Game.new(new_name)
		saved_game
		@@log.raise

	end
	
	def insert_name

		if @click == 1
		  @@info.raise
			@click -= 1
			@@inst_resume.value = 'Instructions'#Resume button becomes 'Instructions' button again
		end

		@@info.state ('normal')
	  @@info.delete(1.0, 'end') #deletes everything in the text widget once name is entered
		new_name = @@player.value
		if new_name.length == 0
			@@log.focus
		else
      new_name[0] = new_name[0].capitalize 	
		
		  file = open(@@user_text) #opening the file with userss names
      list = file.read #reading names and storing in list as string
      list2 = list.split(' ') #converting string of names into array
		
		  @@name_array = list2
      @@name_array.sort!.uniq!
      @@users.values = @@name_array
		
		  file = open(@@user_text, 'a')
		  if @@name_array.include? new_name
		  else
        file.write(' ' + new_name)
        file.close
		  end
		
		  file = open(@@user_text) #opening the file with userss names
      list = file.read #reading names and storing in list as string
      list2 = list.split(' ') #converting string of names into array
		
		  @@name_array = list2
      @@name_array.sort!.uniq!
      @@users.values = @@name_array
			
			@@button.state ('!disabled')
		  @@info.delete(1.0, 'end') #deletes everything in the text
		  @@info.insert(1.0, "Welcome #{new_name}. Start playing the game")
		  @@player.value = ""
		  @@info.state ('disabled')
			Game.new(new_name)
      saved_game
		end
	end
	
	def quick_game
	  @@start.value = 'Start'
		if @click == 1
		  @@info.raise
			@click -= 1
			@@inst_resume.value = 'Instructions'#Resume button becomes 'Instructions' button again
		end
		@@text.value = ""
		@@arrayb.each {|x| x['style'] = 'Normal.TButton'}	
    @@users.state ('disabled')
		@@log.state ('disabled')
		@@f.state ('!disabled')
		@@button.state ('!disabled')
	  @@gamenum.value = ""
		@@info.state ('normal')
	  @@info.delete(1.0, 'end') #deletes everything in the text widget 
	  QuickGame.new()

	end
	
		def log_in
		@@selection.value = 'Select a level to play'
		@@start.value = 'Start'
		@@arrayb.each {|x| x.state ('disabled')}
		@@text.value = ""
	  @@arrayb.each {|x| x['style'] = 'Normal.TButton'}	
	  @@button.state('disabled')
	  @@answer.state ('disabled')
		@@info.state ('normal')
		@@info.delete(1.0, 'end') #deletes everything in the text 
		@@info.state ('disabled')
	  @@users.state ('!disabled')
		@@gamenum.value = ""
		@@f.state ('disabled')
		@@users.state('readonly')
		@@users.raise
	end
	
	def sign_up
	  @@selection.value = 'Select a level to play'
		@@start.value = 'Start'
	  @@arrayb.each {|x| x.state ('disabled')}
		@@text.value = ""
	  @@arrayb.each {|x| x['style'] = 'Normal.TButton'}	
	  @@button.state('disabled')
	  @@answer.state ('disabled')
		@@info.state ('normal')
		@@info.delete(1.0, 'end') #deletes everything in the text 
		@@info.state ('disabled')
	  @@log.state ('!disabled')
		@@gamenum.value = ""
	  @@f.state ('disabled')
		@@log.focus
		@@log.raise
	end
	
	def game_rules
	  
		if @click  == 0 
			@@instruction.raise
			@click += 1
			@@inst_resume.value = 'Resume'#Instructions button becomes 'Resume' button
		elsif @click == 1
		  @@info.raise
			@click -= 1
			@@inst_resume.value = 'Instructions'#Resume button becomes 'Instructions' button again
			if @@entry.state ==('disabled')
			  @@f.focus  #focus on spinbox if game was not started
			else
			  @@entry.focus  #focus on entry if game was started
			end
		end
	end
			
	def clear
	  ask = Tk::messageBox :type => 'yesno', 
	  :message => "Are you sure you want to clear user list\nThis will also delete all of the high scores", 
	  :icon => 'question', :title => 'Reset'
		
		if ask == 'yes'
	    file = open(@@user_text, 'a')
		  file.truncate(0)
		  file.close
		  @@name.value = ""
		
		  file = open(@@user_text) #opening the file with userss names
      list = file.read #reading names and storing in list as string
      list2 = list.split(' ') #converting string of names into array
		
		  @@name_array = list2
      @@name_array.sort!.uniq!
      @@users.values = @@name_array
			
			files = {"one" => 1, "two" => 2, "three" => 3, "four" => 4, "five" => 5, "six" => 6, "seven" => 7, "eight" => 8, "nine" => 9, "ten" => 10}

		  @@json.each do |x| 
			  empty ={}
			  File.open(x, 'w') do |f|
		      f.write(empty)
			  end
			end
		@@info.state ('normal')
		@@info.delete(1.0, 'end') #deletes everything in the text 
		@@info.state ('disabled')
		end #ends if statement
		
	end
	
end
	
	User.new()
 	Tk.mainloop
