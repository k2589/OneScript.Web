#Использовать entity
#Использовать json

Перем мПутьКФайлуНастроек;
Перем БазаСоздана Экспорт;

Перем МенеджерСущностей;
Перем ХранилищеНоменклатуры;

Процедура Инициализация() Экспорт

	МенеджерСущностей = Новый МенеджерСущностей(Тип("КоннекторSQLite"), "FullUri=file::memory:?cache=shared");
	МенеджерСущностей.ДобавитьКлассВМодель(Тип("Номенклатура"));

	МенеджерСущностей.Инициализировать();
	ХранилищеНоменклатуры = МенеджерСущностей.ПолучитьХранилищеСущностей(Тип("Номенклатура"));

	Сообщить("База создана", СтатусСообщения.Информация);

	Парсер = Новый ПарсерJSON;
	Данные = Парсер.ПрочитатьJSON(ПрочитатьИсходныеДанные(),,,Истина);
	Если ТипЗнч(Данные) <> Тип("Массив") Тогда
		Возврат;
	КонецЕсли;

	Для каждого Объект Из Данные Цикл
		ДобавитьНоменклатуру(Объект);
	КонецЦикла;

	// для проверки
	Массив = ПолучитьСписокНоменклатуры(); // test
	Сообщить("Количество записей в базе: " + Массив.Количество(), СтатусСообщения.Информация);

	Для Каждого Номенклатура Из Массив Цикл
		Сообщить(Номенклатура.name, СтатусСообщения.Информация);
	КонецЦикла;
	
	БазаСоздана = Истина;

КонецПроцедуры

Функция ПрочитатьИсходныеДанные()
	
	Файл = Новый Файл(мПутьКФайлуНастроек);
	Если Не Файл.Существует() Тогда
		Содержимое = "[]";
	Иначе
		Текст = Новый ЧтениеТекста(мПутьКФайлуНастроек);
		Содержимое = Текст.Прочитать();
		Текст.Закрыть();
	КонецЕсли;
	
	Возврат Содержимое;
	
КонецФункции

Процедура ДобавитьНоменклатуру(Данные) Экспорт

	Номенклатура = Новый Номенклатура();
	Номенклатура.name = Данные["name"];
	Номенклатура.article = Данные["article"];
	Номенклатура.description = Данные["description"];
	Номенклатура.price = РаспарситьЦену(Данные);

	ХранилищеНоменклатуры.Сохранить(Номенклатура);

	Сообщить("Добавлена номенклатура " + Номенклатура.description, СтатусСообщения.Информация);

КонецПроцедуры

Функция ПолучитьЭлементНоменклатуры(Знач Идентификатор) Экспорт

	Возврат ХранилищеНоменклатуры.ПолучитьОдно(Идентификатор);

КонецФункции

Процедура УдалитьЭлементНоменклатуры(Знач Идентификатор) Экспорт

	Номенклатура = ХранилищеНоменклатуры.ПолучитьОдно(Идентификатор);
	ХранилищеНоменклатуры.Удалить(Номенклатура);

КонецПроцедуры

Процедура ИзменитьЭлементНоменклатуры(Знач Данные, Знач Идентификатор) Экспорт
	
	Номенклатура = ХранилищеНоменклатуры.ПолучитьОдно(Идентификатор);
	Номенклатура.name = Данные["name"];
	Номенклатура.article = Данные["article"];
	Номенклатура.description = Данные["description"];
	Номенклатура.price = РаспарситьЦену(Данные);

	ХранилищеНоменклатуры.Сохранить(Номенклатура);

КонецПроцедуры

Функция ПолучитьСписокНоменклатуры() Экспорт

	Возврат ХранилищеНоменклатуры.Получить();
	
КонецФункции

Процедура ЗаписатьДанныеВФайл() Экспорт

	Текст = Новый ЗаписьТекста(мПутьКФайлуНастроек);
	Запись = Новый ПарсерJSON;
	ТЗ = ПолучитьСписокНоменклатуры();
	Текст.Записать(Запись.ЗаписатьJSON(ТЗ));
	Текст.Закрыть();

КонецПроцедуры

Функция РаспарситьЦену(Данные)
	Цена = Данные["price"];
	Если Цена = Неопределено ИЛИ Цена = "" Тогда
		Цена = 0.0;
	Иначе
		Цена = Число(Цена);
	КонецЕсли;

	Возврат Цена;
КонецФункции

///////////////////////////////////////////////////
мПутьКФайлуНастроек = "appData.json";
БазаСоздана = Ложь;