extends Node


const DAYS_PER_MONTH = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
var date: String
var days: int


func set_date(new_date: String):
	self.date = new_date
	self.days = self.date_to_days(new_date)
	$Soleil.set_planets_positions(self.days)

static func is_year_bissextile(year: int) -> bool:
	return (year % 4 == 0 and
		((not year % 100 == 0) or year % 400 == 0))

static func count_bissextile_years(year: int) -> int:
	var count: int = 0
	var year_bissextile: int = 0
	while year_bissextile < year:
		if is_year_bissextile(year_bissextile):
			count += 1
		year_bissextile += 4
	return count

static func days_to_date(days: int) -> String:
	var year: int = 0
	var month: int = 1
	while days > 364:
		if is_year_bissextile(year):
			if days == 365:
				break
			days -= 366
		else:
			days -= 365
		year += 1
	for days_in_month in DAYS_PER_MONTH:
		if days > days_in_month:
			days -= days_in_month
			month += 1
		else:
			break
	return "%04d-%02d-%02d" % [year, month, days]

# return -1 if the date is invalid. Else returns the number of days in
static func date_to_days(date: String) -> int:
	if date.length() != 10:
		return -1
	var date_parsed = date.split("-")
	if date_parsed.size() != 3:
		return -1
	var year: String = date_parsed[0]
	var month: String = date_parsed[1]
	var day: String = date_parsed[2]
	var year_int: int = int(year)
	var month_int: int = int(month)
	var day_int: int = int(day)
	
	if year.length() != 4:
		return -1
	if year_int == 0 and year != "0000":
		return -1
	if month.length() != 2:
		return -1
	if month_int <= 0 || month_int > 12:
		return -1
	if day.length() != 2:
		return -1
	if day_int <= 0 || day_int > DAYS_PER_MONTH[month_int - 1]:
		return -1
	var bissextile_count = 0
	if year_int != 0:
		bissextile_count = count_bissextile_years(year_int)
	var total_days = (year_int) * 365 + bissextile_count + day_int
	for month_nb in range(1, month_int):
		total_days += DAYS_PER_MONTH[month_nb - 1]
	return total_days

func _ready() -> void:
	$TickCounter.stop()
	self.set_date($"Tableau de bord/Date".text)
	print("date_to_days(2021-06-13) = ", date_to_days("2021-06-13"))
	print("days_to_date(738760) = ", days_to_date(738760))

func _on_Tableau_de_bord_date_changed(new_date: String) -> void:
	var new_date_days: int = self.date_to_days(new_date)
	if new_date_days == -1:
		# TODO: say why ?
		$"Tableau de bord/Date".text = self.date
	else:
		self.set_date(new_date)

func _on_Tableau_de_bord_speed_changed(new_speed: int) -> void:
	$TickCounter.wait_time = 1.0 / float(new_speed)

func _on_Tableau_de_bord_start_pressed() -> void:
	if $TickCounter.is_stopped():
		$TickCounter.start()
	else:
		$TickCounter.stop()

func _on_TickCounter_timeout() -> void:
	self.days += 1
	self.date = days_to_date(self.days)
	$"Tableau de bord/Date".text = self.date
	$Soleil.set_planets_positions(self.days)
