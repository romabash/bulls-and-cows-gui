require 'tk'
require 'tkextlib/tile'
require_relative 'kbmodule'

class QuickGame 

  include Layout

  def initialize()

    @array1 = [] 
    @array2 = []
	  @count = 0
		
		@@selection.value = 'Select a level to play'
	  @@f.focus #cursor focuses on spinbox at the begning
	  @@entry.state ('disabled')
    @@answer.state ('disabled')
	  @@info.state ('disabled')
	  @@f.bind("Return") {start_game} #binds f to start_game method (same as clicking 'Start' button)
    @@entry.bind("Return") {display_info} #binds entry to display_info method to display in the the text widget
	
	  begining = proc {start_game}
	  show = proc {answer}
	  @@button['command'] = begining
    @@answer['command'] = show
		
	  @@arrayb.each {|x| x.state ('disabled')}
    @c0, @c1, @c2, @c3, @c4, @c5, @c6, @c7, @c8, @c9 = 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	  @arrayc = [@c0, @c1, @c2, @c3, @c4, @c5, @c6, @c7, @c8, @c9]
		@@arrayb.each {|x| x['command'] = proc {color(x)}}
  
  end
	
	
  def color(x)

    if @arrayc[@@arrayb.index(x)] == 0
      x['style'] = 'Green.TButton' 
      @arrayc[@@arrayb.index(x)] += 1
    elsif @arrayc[@@arrayb.index(x)] == 1
      x['style'] = 'Red.TButton'
      @arrayc[@@arrayb.index(x)] += 1
    elsif @arrayc[@@arrayb.index(x)] == 2
      x['style'] = 'Normal.TButton'
	  	@arrayc[@@arrayb.index(x)] -= 2
	  end
	  @@entry.focus
  end
	
	  #resets the color clicks for the new game
	def reset(x)
	    if @arrayc[@@arrayb.index(x)] != 0 
        @arrayc[@@arrayb.index(x)] = 0
		  end
	end
			
	
  def start_game

	  @@arrayb.each {|x| reset(x)} #resets the color clicks at the beggining of new game
  	@@arrayb.each {|x| x['style'] = 'Normal.TButton'} #resets the color of buttons

  	@@info.state ('normal')
    @@info.delete(1.0, 'end') #deletes everything in the text widget once new game starts
    @@info.state ('disabled')
    @array1.clear #clears array when New game starts
    @@text.value = "Enter #{@@gamenum} numbers:" #Label displays how many numbers to enter based on the selection

    @@start.value = 'New Game'#Start button becomes 'New Game' button
    @@guess.value = "" 
    @@entry.state ('!disabled') #Enables the entry for user input
    @@answer.state ('!disabled') #Enables the 'Answer' button for the answer
    @@arrayb.each {|x| x.state ('!disabled')} #Enables the 'number' buttons for the color
    @@entry.focus #Focus shifts from 'f' spinbox to the entry
	
	    #makes sure that the number selected is between 1 and 9
	  if @@gamenum <= 0 || @@gamenum > 10
	    @@f.value = ""
	    @@f.focus
			@@info.state('normal')
	    @@info.insert(1.0, "Select level from 1 - 10")
			@@info.state('disabled')
	    @@start.value = 'Start'
	    @@entry.state ('disabled')
      @@answer.state ('disabled')
		  @@arrayb.each {|x| x.state ('disabled')} 
	    @@text.value = ""
	  else
      begin #creates the number to guess based on how many numbers user selects (gamenum)
	  	  until @array1.length == @@gamenum do 
          number = rand(0..9)
          next if @array1.include?(number)
          @array1 << number
        end 
      rescue #rescues if no number was selected in the 'f' spinbox
	    	@@f.value = ""
	      @@f.focus
			  @@info.state('normal')
	      @@info.insert(1.0, "Select how many numbers to play first")
			  @@info.state('disabled')
	      @@start.value = 'Start'
	      @@entry.state ('disabled')
        @@answer.state ('disabled')
	  		@@arrayb.each {|x| x.state ('disabled')} 
	      @@text.value = ""
      end 
	  end
  end

  def display_info()

    bull = 0 
    cow = 0

    input = @@guess.to_s.split(//)
    input.each {|i| @array2 << i.to_i}  
  
    if @array2.length != @@gamenum
      @@guess_info = "make sure to use #{@@gamenum} numbers"
	  	@@info.state ('normal')
      @@info.insert('end', "#{@@guess_info} \n")
			@@info.see('end')
	  	@@info.state ('disabled')
    elsif @array2 != @array2.uniq
      @@guess_info = "make sure to not duplicate numbers"
  		@@info.state ('normal')
      @@info.insert('end', "#{@@guess_info} \n")
			@@info.see('end')
  		@@info.state ('disabled')
    else 
      n = 0
      while n < @@gamenum
        if @array1[n] == @array2[n]
          bull += 1
        elsif @array1.include?(@array2[n]) 
          cow += 1
        end #ends if statement for counting bulls and cows
        n += 1
      end #ends while loop for counting all bulls and cows 
    @count += 1
      if cow == 0 && bull == 0
        @@guess_info = "No matches"
	  		@@info.state ('normal')
        @@info.insert('end', "#{@array2.join(" ")}:  #{@@guess_info} \n")
				@@info.see('end')
	  		@@info.state ('disabled')
      elsif cow == 0
        @@guess_info = "#{bull} bulls"
	  		@@info.state ('normal')
        @@info.insert('end', "#{@array2.join(" ")}:  #{@@guess_info} \n")
				@@info.see('end')
	  		@@info.state ('disabled')
      elsif bull == 0
        @@guess_info = "#{cow} cows"
		  	@@info.state ('normal')
        @@info.insert('end', "#{@array2.join(" ")}:  #{@@guess_info} \n")
				@@info.see('end')
  			@@info.state ('disabled')
      else
        @@guess_info = "#{bull} bulls and #{cow} cows"
			  @@info.state ('normal')
        @@info.insert('end', "#{@array2.join(" ")}:  #{@@guess_info} \n")
				@@info.see('end')
	  		@@info.state ('disabled')
      end #ends if statement for displaying number of bulls and cows
    end #ends if statement for checking numbers entered
    

    @@guess.value = ""
    @array2.clear
  
    finish_game if bull == @@gamenum

  end  

  def finish_game
  
    @@guess.value = "" 
    @@entry.state ('disabled')
	  @@arrayb.each {|x| x['style'] = 'Normal.TButton'}
	  @@arrayb.each {|x| x.state ('disabled')}
	
    @@info.state ('normal')
	  @@text.value = ''
	  @@info.insert('end', "\n\tYou Win!!! It took you #{@count} steps.\n\t\tStart New Game \n")
		@@info.see('end')
	  @count = 0
  	@@info.state ('disabled')
    @@f.focus
  end

  def answer

	  @@guess.value = "" 
    @@entry.state ('disabled')
	  @@arrayb.each {|x| x['style'] = 'Normal.TButton'}
	  @@arrayb.each {|x| x.state ('disabled')}
	  @@text.value = ''
  	@@answer.state ('disabled')
  	
		@@info.state ('normal')
    @@info.insert('end', "\n\tThe answer is:  #{@array1.join(" ")}\n")
		@@info.see('end')
	  @@info.state ('disabled')
    @@f.focus

  end

end




