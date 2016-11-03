class View
	# Recuerda que la única responsabilidad de la vista es desplegar data al usuario
  # Los siguientes métodos son sólo un ejemplo:
  
  # AQUI SE DESPLIEGAN TODOS LOS MENUS DE BIENVENIDA
	#Metodo que muestra el primer menu
  def display_welcome_menu
    puts "Bienvenido a Vuelos Codea"
    puts "-"*50
    puts "1) Reservaciones"
    puts "2) Administrador"
    puts "3) Salir"
    puts
    puts "Selecciona opción:"
    input = gets.chomp
    input
  end

  #Metodo que despliega el segundo menu para mostrar reservaciones
  def display_reservations_menu
    puts "-"*50
    puts "          ¡¡¡Bienvenido!!!"
    puts "-"*50
    puts 
    puts "1) Encuentra tu boleto de avión"
    puts "2) Salir"
    puts "Selecciona una opción:"
    input = gets.chomp
    input
  end  

  # Metodo que recolecta los requisitos del usuario para su vuelo 
  def collect_info_for_flight_search
    flight_to_find = []
    puts "-"*50
    puts "          ¡¡¡Encuentra tu vuelo!!!"
    puts "-"*50
    puts 
    puts "From:"
    flight_to_find << gets.chomp
    puts "To:" 
    flight_to_find << gets.chomp
    puts "Date:"
    flight_to_find << gets.chomp
    puts "Passenger:"
    flight_to_find << gets.chomp
    flight_to_find
  end  

  #Muestra los vuelos de la base de datos que cumplen los requisitos
  def display_solicited_flight(flights, query)
    puts "-"*80
    puts "Vuelos disponibles From: #{query[0]} To: #{query[1]}"
    puts "-"*80
    if flights.empty? 
      puts "No se encontraron vuelos disponibles para tu destino"
    else 
      num = 0
      flights.each do |flight|
        num += 1
        puts "#{num}) No Vuelo: #{flight.num_flight}"
        puts "Date: #{flight.date}, Depart: #{flight.depart} UTC From: #{flight.from},"
        puts "To: #{flight.to}, Duration: #{flight.duration}, Precio:#{flight.cost}, Lugares:#{flight.passenger}"
        puts "-"*80
      end  
      puts "Selecciona tu vuelo:"
    end
    input = gets.chomp
    reservation = [input,query[3],flights]
    
  end 

  #AQUI VAN TODAS LAS FUNCIONES DE LOGIN
  #Ofrece al usuario la opcion de registrarse o hacer login
  def display_login_options
    puts "-"*60
    puts "Para reservar tu vuelo necesitas"
    puts "1) Registrarte "
    puts "2) Login"
    puts "Elige una opción:"    
    input = gets.chomp
    puts "-"*60
    input
  end 

  #Recopila la informacion de registro del usuario
  def display_registration
    register_user = []
    puts "Ingresa tu nombre"
    register_user << gets.chomp
    puts "Ingresa tu email"
    register_user << gets.chomp
    register_user << "false"
    puts "-"*60
    puts "Te has registrado con exito"
    puts "-"*60
    register_user
  end 
  
  #Recopila la informacion de login del usuario
  def display_login 
    puts "-"*60
    puts "          Bienvenido a Login"
    puts "-"*60
    login_info = []
    puts "Ingresa tu nombre"
    login_info << gets.chomp
    puts "Ingresa tu email"
    login_info << gets.chomp
    login_info
  end  

  #Muestra si el login fue exitoso
  def login_validate(status)
    if status.empty? 
      puts "Nombre o correo electronico no valido"
    elsif status.count == 1
      puts "Login exitoso, Bienvenido"
    end
  end  

  #Metodo que hace login del administrador
  def admin_login
    admin_user = []
    puts "-"*80
    puts "Bienvenido administrador"
    puts "-"*80
    puts 
    puts "Ingresa tu nombre"
    admin_user << gets.chomp
    puts "Ingresa tu email"
    admin_user << gets.chomp
    admin_user    
  end  

  #Despliega la informacion del vuelo a confirmar, la informacion del usuario loggeado y solicita la informacion de los pasajeros restantes
  def show_reservation(seats,flight,user1)
    puts "-"*80
    puts "Número de Vuelo Seleccionado: #{flight[0]}"
    puts "-"*80
    puts "Date: #{flight[1]}, Depart: #{flight[2]}"
    puts "From: #{flight[3]}, To: #{flight[4]} , Duration: #{flight[5]}, Precio: #{flight[6]} pesos"
    puts "-"*80
    puts
    puts "Datos de Persona 1:"
    puts "Ingresa tu nombre :" 
    puts "#{user1[1]}" 
    puts "email:"
    puts "#{user1[2]}"
    users_to_register = []
    for i in (2..seats) 
      puts "Ingresa los datos de los otros pasajeros"
      puts "Datos de Persona #{i}:"
      puts "Ingresa nombre :" 
      users_to_register << gets.chomp
      puts  "email:"
      users_to_register << gets.chomp
      users_to_register << "false"
    end 
    puts "Realizar reservacion 1) Si  2) No"
    input = gets.chomp
    users_to_register << input 
    users_to_register
  end 
  
  #Muestra la clave de conformacion y el ticket total al usuario
  def show_ticket(ticket)
    puts "-"*80
    puts "Estamos muy felices de que hayas reservado con nosotros!!!"
    puts "-"*80
    puts 
    puts "El costo total es de $ #{ticket[0]} pesos"
    booking = ticket[1]
    puts "Y tu ID de reservación es la siguiente: #{booking.id} "
    puts "-"*80
  end  

  #AQUI SE ENCUENTRAN TODAS LAS VISTAS DEL ADMINISTRADOR
  #Mertodo que muestra el primer menu del administrador
  def show_admin_menu
    puts "-"*80
    puts "¿Que deseas hacer?"
    puts "-"*80
    puts "1) Mostrar todos los vuelos"
    puts "2) Mostrar todas las reservaciones"
    puts "3) Agrega un vuelo"
    puts "4) Salir"
    # puts "5) Borrar vuelos"
    # puts "6) Borrar reservaciones"

    puts 
    puts "Selecciona opción:"
    input = gets.chomp
    input
  end  

  #Muestra todos los vuelos al administrador
  def show_flight(flights)
    puts "Estos son todos los vuelos programados"
    puts "-"*80
    puts
    if flights.empty? 
       puts "No hay vuelos programados en este momento"
    else 
      num = 0
      flights.each do |flight|
        num += 1
        puts "#{num}) No Vuelo: #{flight.num_flight}"
        puts "Date: #{flight.date}, Depart: #{flight.depart} UTC From: #{flight.from},"
        puts "To: #{flight.to}, Duration: #{flight.duration}, Precio:#{flight.cost}, Lugares:#{flight.passenger}"
        puts "-"*80
      end
    end   
  end  

  #Muestra todas las reservaciones al administrador
  def show_reservations(reservations)
    puts "Estas son todas las reservaciones existentes"
    puts "-"*80
    if reservations.empty? 
      puts "No hay reservaciones en este momento"
    else 
      num = 0 
      reservations.each do |reservation|
        num += 1
        puts "#{num}) ID de reservacion #{reservation.id}"
        puts "Booking number: #{reservation.num_booking}, Costo total: $#{reservation.total_cost} pesos, ID de vuelo: #{reservation.flight_id}"
        puts "-"*80
      end  
    end   
  end  

  #Recolecta toda la informacion para un nuevo vuelo
  def new_flight_info
    new_flight = []
    puts "Introduce la información del vuelo a crear"
    puts "-"*80
    puts "Coloca el numero de vuelo"
    new_flight << gets.chomp
    puts "Coloca la fecha en la que sera el vuelo en el siguiente formatoYYYY-MM-DD"
    new_flight << gets.chomp
    puts "Coloca la  hora en la que saldra el vuelo en el siguiente formato HH:MM:SS"
    new_flight << gets.chomp
    puts "Coloca la ciudad de la que saldra el vuelo"
    new_flight << gets.chomp
    puts "Coloca la ciudad de destino"
    new_flight << gets.chomp
    puts "Coloca la duracion del vuelo en el siguiente formato '1 hora 30 minutos'"
    new_flight << gets.chomp
    puts "Establece el precio para este vuelo"
    new_flight << gets.chomp
    puts "Coloca el numero asientos disponibles para este vuelo"
    new_flight << gets.chomp
    new_flight
  end  

  #Muestra el id del vuelo que fue creado 
  def confirmed_new_flight(flight)
    confirmation = flight
    puts "-"*80
    puts "Tu vuelo ha sido creado con exito"
    puts "-"*80
    puts "Este es el id de tu vuelo #{confirmation.id}"
    puts "No Vuelo: #{confirmation.num_flight}"
    puts "Date: #{confirmation.date}, Depart: #{confirmation.depart} From: #{confirmation.from},"
    puts "To: #{flight.to}, Duration: #{confirmation.duration}, Precio:#{confirmation.cost}, Lugares:#{confirmation.passenger}"
    puts "-"*80
  end 

  #Recolecta el numero de vuelo a borrar
  # def flight_to_delete
  #   puts "-"*80
  #   puts "Por favor introduce el numero de vuelo que deseas borrar"
  #   puts "-"*80
  #   flight = gets.chomp
  #   flight
  # end 

  #Recolecta la informacion del vuelo a borrar 
  # def reservation_to_delete
  #   puts "-"*80
  #   puts "Por favor introduce el numero de reservacion que deseas borrar"
  #   puts "-"*80
  #   reservation = gets.chomp
  #   reservation
  # end   


  def good_bye
   puts "Gracias por visitarnos. Regresa pronto"  
  end  
end
