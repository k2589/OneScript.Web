Функция Index() Экспорт
	
	ТаблицаНоменклатуры = МенеджерБазы.ПолучитьСписокНоменклатуры();
	Возврат Представление(ТаблицаНоменклатуры);

КонецФункции

Функция Add() Экспорт

	Если ЗапросHttp.Метод = "POST" Тогда
							
		МенеджерБазы.ДобавитьНоменклатуру(ЗапросHttp.ДанныеФормы);						 

		Возврат Перенаправление("/goods/index");
	КонецЕсли;
	
	Возврат Представление("Item");

КонецФункции

Функция Edit() Экспорт

	Идентификатор = ЗначенияМаршрута["id"];
	Если Идентификатор = Неопределено Тогда
		Возврат Перенаправление("/goods/index");
	КонецЕсли;

	Элемент = МенеджерБазы.ПолучитьЭлементНоменклатуры(Идентификатор);
	
	Если Элемент = Неопределено Тогда
		Возврат КодСостояния(404);
	КонецЕсли;

	Если ЗапросHttp.Метод = "POST" Тогда
		
		МенеджерБазы.ИзменитьЭлементНоменклатуры(ЗапросHttp.ДанныеФормы, Идентификатор);	
		
		Возврат Перенаправление("/goods/index");
	Иначе
		// Передаем в представление "модель" - Элемент
		Возврат Представление("Item", Элемент);
	КонецЕсли;
	
КонецФункции

Функция Delete() Экспорт

	Идентификатор = ЗначенияМаршрута["id"];
	Если Идентификатор = Неопределено Тогда
		Возврат Перенаправление("/goods/index");
	КонецЕсли;
		
	Если ЗапросHttp.Метод = "POST" Тогда
		
		МенеджерБазы.УдалитьЭлементНоменклатуры(Идентификатор);
		
		Возврат Перенаправление("/goods/index");

	КонецЕсли;
	
	Возврат КодСостояния(405);

КонецФункции

Функция Backup() Экспорт

	МенеджерБазы.ЗаписатьДанныеВФайл();
	Возврат Перенаправление("/goods/index");

КонецФункции