class Controller 
  $flights_for_reservation = [] #Variable que guarda los vuelos solicitaos por el ususario para ser usados por todos los metodos de la clase
  $user_for_reservation = [] #Variable que guarda la informacion del user logeado para ser usado por todos los metodos de la clase
  def initialize(args)
    @view = View.new
    welcome(@view.display_welcome_menu)
  end
   
  #Metodo que despliega el menu de bienvenida
  def welcome(args)
    option = args
    case option
      when "1" then reservation_welcome
      when "2" then admin_login
      when "3" then good_bye  
    end  
  end 
 
  
 #Metodo que controla el menu de reservaciones para un usuario no administrador
  def reservation_welcome
    option = @view.display_reservations_menu
    case option
      when "1" then find_flight
      when "2" then good_bye   
    end
  end 
 
  #Metodo para encontrar todos los vuelos que cumplen los requisitos del usuario 
  def find_flight
    flight_querry = @view.collect_info_for_flight_search #regresa un arreglo con los requsitos del usuario
    solicited_flight = []
    total_flights = Flight.all #llama a toda la base de datos 
    total_flights.each do |flight| #Se itera sobre toda la base para seleccionar los que cumplen con la condicion 
       if flight.from == flight_querry[0] && flight.to == flight_querry[1] && flight.date == flight_querry[2] &&  flight_querry[3].to_i < flight.passenger 
        solicited_flight << flight
      end 
    end 
    selected_flight = @view.display_solicited_flight(solicited_flight,flight_querry)
    if solicited_flight.empty?
      reservation_welcome
    else 
      $flights_for_reservation << selected_flight
      login_user_options
    end
  end

  #METODOS PARA EL LOGIN
  #Metodo que ofrece al usuario las opciones para entrar al area de reservaciones
  def login_user_options
    option = @view.display_login_options
    case option
     when "1" then add_user
     when "2" then login_user
    end   
  end 

  def admin_login
    login_info = @view.admin_login
    total_users = User.all
    login_validation = []
    total_users.each do |user|
      if login_info[0] == user.name && login_info[1] == user.email && user.admin == true
        login_validation << user
      end
    end 
    @view.login_validate(login_validation)
    if login_validation.empty?
      admin_login
    else 
      administrator_menu 
    end 
  end   

  #Metodo que agrega los usuarios con registros de primera vez a la base de datos
  def add_user
    register_user = @view.display_registration                           
    User.create(name: register_user[0], email: register_user[1]) 
    login_user
  end                                                            
 
  #Metodo que valida el login del user
  def login_user
    user_info = @view.display_login
    total_users = User.all
    login_validation = []
    total_users.each do |user|
      if user_info[0] == user.name && user_info[1] == user.email
        login_validation << user
      end
    end
    #@view.login_validate(login_validation)
    if login_validation.empty? 
      @view.login_validate(login_validation)
      login_user_options
    else 
      $user_for_reservation = login_validation
      @view.login_validate(login_validation)
      do_reservation
    end  
  end     

  #Metodo que ejercuta todas las acciones necesarias para la reservacion
  def do_reservation
    flight_id = []
    reserved_flight = []
    user_info = []
    flight_selected = $flights_for_reservation[0][0].to_i #Numero de vuelo seleccionado por el usuario 
    seats = $flights_for_reservation[0][1].to_i #Numero de asientos solicitados por el usuario
    flights = $flights_for_reservation[0][2] #Vuelos que fueron mostrados al usuario
    $user_for_reservation #loged user info
    #Modifica el numero de asientos disponibles del vuelo y devuelve un arreglo con la informacion del vuelo en el que se reservo
    flights.each_with_index do |flight, index|
      if index + 1 == flight_selected
        seats_avaliable = flight.passenger - seats
        flight.update_attributes({:passenger => seats_avaliable})
        flight_id << flight.id
        reserved_flight << flight.num_flight << flight.date << flight.depart << flight.from << flight.to << flight.duration << flight.cost
      end   
    #Obtiene la informacion del usuario logeado
    end 
    $user_for_reservation.each do |user|
      user_info << user.id << user.name << user.email
    end   
    #Register user contiene la informacion de los otros usuarios a dar de alta
    register_user = @view.show_reservation(seats,reserved_flight,user_info)
    #Si la reservacion es confirmada crea los nuevos usuarios 
    reservation_confirmation = register_user.last
    repeat = register_user.count / 3 
    num1 = 0 
    num2 = 1
    num3 = 2
    users_created = []
    if reservation_confirmation == "1"
      repeat.times do                                                                      
        users_created << User.create(name: register_user[num1], email: register_user[num2]) 
        num1 += 3 
        num2 += 3
        num3 += 3
      end 
     #Genera la nueva reservacion y los registros de las tablas intermedias
      cost = reserved_flight[6].to_i
      ticket = []
      total_cost =  (cost * seats)
      book_num = rand(2500)
      created_booking = Booking.create(num_booking: book_num, total_cost: total_cost, flight_id: flight_id[0])
      ticket << total_cost << created_booking
      #Genera la tabla intermedia para el usuario loggeado
      UserFlight.create(user_id: user_info[0], flight_id: flight_id[0])
      #Genera los registros de la tabla intermedia del resto de los usuarios de la reservacion
      users_created.each do |user|
        UserFlight.create(user_id: user.id, flight_id: flight_id[0])
      end 
      UserBooking.create(booking_id: created_booking.id, user_id: user_info[0])
      @view.show_ticket(ticket)
      good_bye
    elsif reservation_confirmation == "2"
      good_bye
    end  
  end 

  #Llama a todos los metodos que puede usar el administrador
  def administrator_menu
   option = @view.show_admin_menu
    case option
     when "1" then index_flight
     when "2" then index_reservation
     when "3" then add_flight
     when "4" then good_bye
     # when "5" then delete_flight
     # when "6" then delete_reservation
    end 
  end 
   
 
  #Metodo para mostrar todos los vuelos
  def index_flight
    total_fligths = Flight.all 
    @view.show_flight(total_fligths)  
    administrator_menu 
  end
  
  #Metodo que busca en todas las reservaciones 
  def index_reservation
    reservations = Booking.all
    @view.show_reservations(reservations)
    administrator_menu
  end
 
  #Metodo que agrega un nuevo vuelo
  def add_flight
    new_flight = @view.new_flight_info
    flight = Flight.create(num_flight: new_flight[0],date: new_flight[1],depart: new_flight[2],from: new_flight[3],to: new_flight[4],duration: new_flight[5],cost: new_flight[6],passenger: new_flight[7])
    @view.confirmed_new_flight(flight)
    administrator_menu
  end
 
  #Metodo que destruye vuelos de la base de datos
  # def delete_flight
  #   total_fligths = Flight.all
  #   flight_to_delete = @view.flight_to_delete
  #   total_fligths.each do |flight|
  #     if flight_to_delete == flight.num_flight
  #       deleted_flight = Flight.find_by(num_flight: flight.num_flight).destroy
  #       #Mo se si es correcto borrar tambien esta tabla cuando se borra un registro
  #       UserFlight.find_by(flight_id: flight.id).destroy 
  #     end
  #   end 
  # index_flight    
  # end
  
  #Metodo que borra reservaciones
  # def delete_reservation
  #   reservations = Booking.all
  #   reservation_to_delete = @view.reservation_to_delete
  #   reservations.each do |reservation|
  #     if reservation_to_delete == reservation.num_booking
  #       deleted_reservation = Booking.find_by(num_booking: reservation.num_booking).destroy
  #       UserBooking.find_by(booking_id: reservation.id).destroy
  #     end 
  #   end   
  # index_reservation
  # end
 
  #Metodo de salida
  def good_bye 
    @view.good_bye
  end

end   
 