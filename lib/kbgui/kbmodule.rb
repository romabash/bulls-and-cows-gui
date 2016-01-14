require 'tk'
require 'tkextlib/tile'

TkOption.add '*tearOff', 0

module Layout

  #Setting up the main root and frame that holds all widgets
root = TkRoot.new {title "Korova Byka"}
root.resizable(0,0) #cannot resize

content = Tk::Tile::Frame.new(root) {padding "5 5 12 12"}
content.grid(:column => 4, :row => 0, :columnspan => 3, :rowspan => 5)

  #Frame to keep the click buttons
@@bframe = Tk::Tile::Frame.new(content) 
@@bframe.grid(:column =>3, :row => 3, :columnspan => 3, :sticky => 'we', :padx => '80 20', :pady => '10 5')

Tk::Tile::Style.configure('Normal.TButton')
Tk::Tile::Style.configure('Red.TButton', {"background" => 'red', "foreground" => 'black'})
Tk::Tile::Style.configure('Green.TButton', {"background" => 'green', "foreground" => 'black'})

@@b0 = Tk::Tile::Button.new(@@bframe) {text '0'; width 2; style 'Normal.TButton'}.grid(:column => 0, :row => 0, :sticky => 'we', :padx => 2)
@@b1 = Tk::Tile::Button.new(@@bframe) {text '1'; width 2; style 'Normal.TButton'}.grid(:column => 1, :row => 0, :sticky => 'we', :padx => 2)
@@b2 = Tk::Tile::Button.new(@@bframe) {text '2'; width 2; style 'Normal.TButton'}.grid(:column => 2, :row => 0, :sticky => 'we', :padx => 2)
@@b3 = Tk::Tile::Button.new(@@bframe) {text '3'; width 2; style 'Normal.TButton'}.grid(:column => 3, :row => 0, :sticky => 'we', :padx => 2)
@@b4 = Tk::Tile::Button.new(@@bframe) {text '4'; width 2; style 'Normal.TButton'}.grid(:column => 4, :row => 0, :sticky => 'we', :padx => 2)
@@b5 = Tk::Tile::Button.new(@@bframe) {text '5'; width 2; style 'Normal.TButton'}.grid(:column => 5, :row => 0, :sticky => 'we', :padx => 2)
@@b6 = Tk::Tile::Button.new(@@bframe) {text '6'; width 2; style 'Normal.TButton'}.grid(:column => 6, :row => 0, :sticky => 'we', :padx => 2)
@@b7 = Tk::Tile::Button.new(@@bframe) {text '7'; width 2; style 'Normal.TButton'}.grid(:column => 7, :row => 0, :sticky => 'we', :padx => 2)
@@b8 = Tk::Tile::Button.new(@@bframe) {text '8'; width 2; style 'Normal.TButton'}.grid(:column => 8, :row => 0, :sticky => 'we', :padx => 2)
@@b9 = Tk::Tile::Button.new(@@bframe) {text '9'; width 2; style 'Normal.TButton'}.grid(:column => 9, :row => 0, :sticky => 'we', :padx => 2)
@@arrayb = [@@b0, @@b1, @@b2, @@b3, @@b4, @@b5, @@b6, @@b7, @@b8, @@b9]
  #For resizing
TkGrid.columnconfigure root, 1, :weight => 1;  TkGrid.rowconfigure root, 0, :weight => 1
TkGrid.columnconfigure content, 1, :weight => 1; TkGrid.rowconfigure content, 0, :weight => 1
  
  #Selects how many numbers to play
@@gamenum = TkVariable.new 

  #selection - Asks to select the numbers to play
@@selection = TkVariable.new 
@@select = Tk::Tile::Label.new(content) {textvariable @@selection}
@@select.grid(:column => 3, :row => 1, :columnspan => 2, :pady => '5 10')
  #f - Input for the numbers to be played (from 1 to 10) stored in @@gamenum.  padx to create space between label
@@f = Tk::Tile::Spinbox.new(content) {width 4; from 1.0; to 10.0; textvariable @@gamenum}
@@f.grid(:column => 5, :row => 1, :columnspan => 2, :padx => 5, :pady => '5 10', :sticky => 'w')


  #start holds the title for the button (begins with 'Start' and changes to 'New Game' once clicked)
@@start = TkVariable.new
@@start.value = 'Start'
  #button connected to the start_game methods once clicked
@@button = Tk::Tile::Button.new(content) {textvariable @@start}
@@button.grid(:column => 3, :row => 2, :sticky => 'we', :padx => 20)
  #answer is the button that reveals the answer, connected to the answer method
@@answer = Tk::Tile::Button.new(content) {text 'Answer'}
@@answer.grid(:column => 4, :row => 2, :sticky => 'we', :padx => '10 25')
  #Exit button, connected to its own exit method
@@exit = Tk::Tile::Button.new(content) {text 'Exit'; command 'exit'}
@@exit.grid(:column => 5, :row => 2, :sticky => 'we', :padx => 5)

  #text for Label that says how many numbers to enter, once selected how many numbers to play in selection
@@text = TkVariable.new 
@@label = Tk::Tile::Label.new(content) {textvariable @@text}
@@label.grid(:column => 3, :row => 4, :columnspan => 2, :pady => '10 10')
  #Stores the numbers the player enters as a guess in the entry field
@@guess = TkVariable.new 
@@entry = Tk::Tile::Entry.new(content) {width 10; textvariable @@guess}
@@entry.grid(:column => 4, :row => 4, :columnspan => 2, :padx => 5, :pady => '5 10')

  #displays the results of the player's guess, cows and bull in the text widget
@@guess_info = TkVariable.new 
  
	#create 'display' for the text widget	and instruction 
display = Tk::Tile::Frame.new(content) {padding "2"; relief "sunken"; borderwidth 5; width 100; height 200}
display.grid(:column =>3, :row => 5, :columnspan => 3, :rowspan => 4, :sticky => 'we', :padx => '20 5', :pady => 5) 

  #Instruction Text widget that will be displayed when Instruction button is clicked
@@instruction = TkText.new(display) {width 45; height 12}
@@instruction.grid(:column => 1, :row => 1, :sticky => 'nw')
@@instruction.insert(1.0, "The Rules of the game:\nTo win the game...")

  #text widget that will display user's input and responses
@@info = TkText.new(display) {width 45; height 12}
@@info.grid(:column => 1, :row => 1, :sticky => 'nw')

  #Scroll for the Text
vt = TkScrollbar.new(display) {orient 'vertical'}
vt.grid :sticky => 'ns', :column => 3, :row => 1
@@info.yscrollbar(vt)

  #Menu
menubar = TkMenu.new
root.menu(menubar)

@@file = TkMenu.new(root)
menubar.add('cascade', 'menu' => @@file, 'label' => "File")
@@file.add :separator
@@file.add('command', 'label' => "Exit", 'command' => proc{exit}, 'underline' => 0)

#------------------------------------------------------------------------

left = Tk::Tile::Frame.new(root) {padding "5 5 12 12"}
left.grid(:column => 0, :row => 0, :columnspan => 3) 


  #Buttons
@@quick_game = Tk::Tile::Button.new(left) {text 'Quick Game'; width 15}
@@quick_game.grid(:column => 0, :row => 0, :padx => '10 10', :pady => 20)

@@log_in = Tk::Tile::Button.new(left) {text 'Sign Up'; width 15}
@@log_in.grid(:column => 1, :row => 0, :padx => '10 10', :pady => 20)

@@sel_user = Tk::Tile::Button.new(left) {text 'Sign In'; width 15}
@@sel_user.grid(:column => 2, :row => 0, :padx => '10 10', :pady => 20)

  #High Scores	
@@high_score = Tk::Tile::Button.new(left) {text 'High Scores'; width 15}
@@high_score.grid(:column => 0, :row => 4, :padx => '10 10', :pady => 20)

  #Reset Users Button
@@reset_users = Tk::Tile::Button.new(left) {text 'Reset'; width 15}
@@reset_users.grid(:column => 1, :row => 4, :padx => '10 10', :pady => 20)

  #Instructions Button
@@inst_resume = TkVariable.new
@@inst_resume.value = 'Instructions'
@@game_rules = Tk::Tile::Button.new(left) {textvariable @@inst_resume; width 15}
@@game_rules.grid(:column => 2, :row => 4, :padx => '10 10', :pady => 20)

  #Users
@@name = TkVariable.new
@@users = Tk::Tile::Combobox.new (left) {textvariable @@name; width 15}
@@users.grid(:column => 0, :row => 3, :padx => '10 10', :pady => 20, :columnspan => 3)

@@one = File.join(File.dirname(__FILE__), '../one.json')
@@two = File.join(File.dirname(__FILE__), '../two.json')
@@three = File.join(File.dirname(__FILE__), '../three.json')
@@four = File.join(File.dirname(__FILE__), '../four.json')
@@five = File.join(File.dirname(__FILE__), '../five.json')
@@six = File.join(File.dirname(__FILE__), '../six.json')
@@seven = File.join(File.dirname(__FILE__), '../seven.json')
@@eight = File.join(File.dirname(__FILE__), '../eight.json')
@@nine = File.join(File.dirname(__FILE__), '../nine.json')
@@ten = File.join(File.dirname(__FILE__), '../ten.json')

@@json = [@@one, @@two, @@three, @@four, @@five, @@six, @@seven, @@eight, @@nine, @@ten] 


@@user_text = File.join(File.dirname(__FILE__), '../users.txt')
file = open(@@user_text) #opening the file with userss names
list = file.read #reading names and storing in list as string
list2 = list.split(' ') #converting string of names into array

@@name_array = list2 
@@name_array.sort!.uniq!
@@users.values = @@name_array
@@users.state('readonly')

@@player = TkVariable.new 
@@log = Tk::Tile::Entry.new(left) {width 10; textvariable @@player; width 18}
@@log.grid(:column => 0, :row => 3, :padx => 10, :columnspan => 3)

  #separators

s = Tk::Tile::Separator.new(left) {orient 'vertical'}
s.grid(:column => 3, :row => 0, :sticky => 'ens', :rowspan => 5, :padx => 10)

end