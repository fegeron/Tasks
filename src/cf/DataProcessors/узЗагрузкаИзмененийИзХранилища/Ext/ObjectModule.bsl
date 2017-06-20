﻿Перем мТЗПоискКэш;
Перем мТЗСвойстваМетаданных;
Перем мМассивПользователейКомуОтправлятьСистемныеУведомления;

Функция ЗагрузитьИзмененияИзХранилища(АдресФайлаПолученныйНаКлиенте = Неопределено,ФайлВыгрузкиИзменений = Неопределено) Экспорт
	СоздатьСтруктурумТЗПоискКэш();
	
	Если ФайлВыгрузкиИзменений = Неопределено Тогда
		Если АдресФайлаПолученныйНаКлиенте = Неопределено Тогда
			ФайлВыгрузкиИзменений = ВыгрузитьИзмененияИзХранилища();
		Иначе
			ФайлВыгрузкиИзменений = КаталогВременныхФайлов() + ПолучитьИмяФайлаДляВыгрузки();
			ДвоичныеДанные = ПолучитьИзВременногоХранилища(АдресФайлаПолученныйНаКлиенте);		
			ДвоичныеДанные.Записать(ФайлВыгрузкиИзменений);
		Конецесли;
	Конецесли;
	
	ТабДокИсторияХранилища = Новый ТабличныйДокумент();
	ТабДокИсторияХранилища.Прочитать(ФайлВыгрузкиИзменений);
	ТЗИсторияХранилища = ПолучитьТЗИсторияХранилища(ТабДокИсторияХранилища);
	
	УдалитьФайлы(ФайлВыгрузкиИзменений);
	
	ЗаполнитьмТЗСвойстваМетаданных();
	
	Для каждого СтрокаТЗИсторияХранилища из ТЗИсторияХранилища цикл
		СтрокаТЗИсторияХранилища.Пользователь = ПолучитьПользователя(СтрокаТЗИсторияХранилища);
		СтрокаТЗИсторияХранилища.Задача = ПолучитьЗадачу(СтрокаТЗИсторияХранилища);
		
		Если НЕ ЗначениеЗаполнено(СтрокаТЗИсторияХранилища.Задача) Тогда
			узОбщийМодульСервер.узСообщить("Ошибка! не заполнена задача в комментарии хранилища, загрузка прервана",76);
			РезультатФункции = Новый Структура();
			РезультатФункции.Вставить("ТабДокОтчет",ТабДокИсторияХранилища);
			Возврат РезультатФункции;
		Конецесли;
		
		Для каждого СтрокаТЗИзмененныеОбъекты из СтрокаТЗИсторияХранилища.ТЗИзмененныеОбъекты цикл
			СтрокаТЗИзмененныеОбъекты.ИдентификаторОбъектаМетаданных = ПолучитьИдентификаторОбъектаМетаданныхПоСтроке(СтрокаТЗИзмененныеОбъекты.ТекстИдентификатораОбъектаМетаданных);		
		Конеццикла;
	Конеццикла;
	
	СохранитьИсториюХранилищаВБД(ТЗИсторияХранилища);
	
	РезультатФункции = Новый Структура();
	РезультатФункции.Вставить("ТабДокОтчет",ТабДокИсторияХранилища);
	Возврат РезультатФункции;
КонецФункции 

Процедура ЗаполнитьмТЗСвойстваМетаданных() Экспорт 
	мТЗСвойстваМетаданных = Новый ТаблицаЗначений;
	мТЗСвойстваМетаданных.Колонки.Добавить("Родитель");
	мТЗСвойстваМетаданных.Колонки.Добавить("Имя");
	мТЗСвойстваМетаданных.Колонки.Добавить("ПорядокКоллекции");
	
	Макет = ПолучитьМакет("СвойстваМетаданных");

	Для НомерСтроки = 2 По Макет.ВысотаТаблицы Цикл
		пРодитель = СокрЛП(Макет.Область(НомерСтроки,1).Текст);
		пИмя = СокрЛП(Макет.Область(НомерСтроки,2).Текст);
		пПорядокКоллекции = СокрЛП(Макет.Область(НомерСтроки,3).Текст);
		
		СтрокамТЗСвойстваМетаданных = мТЗСвойстваМетаданных.Добавить();
		СтрокамТЗСвойстваМетаданных.Родитель = пРодитель;
		СтрокамТЗСвойстваМетаданных.Имя = пИмя;
		СтрокамТЗСвойстваМетаданных.ПорядокКоллекции = Число(пПорядокКоллекции);
		
	КонецЦикла;
	
КонецПроцедуры

Процедура СоздатьСтруктурумТЗПоискКэш() Экспорт
	мТЗПоискКэш = Новый ТаблицаЗначений();
	мТЗПоискКэш.Колонки.Добавить("МетаданныеИмя");
	мТЗПоискКэш.Колонки.Добавить("Код");
	мТЗПоискКэш.Колонки.Добавить("Наименование");
	мТЗПоискКэш.Колонки.Добавить("ЭтоГруппа");
	мТЗПоискКэш.Колонки.Добавить("Ссылка");
	мТЗПоискКэш.Колонки.Добавить("Владелец");
	мТЗПоискКэш.Колонки.Добавить("Родитель");
	мТЗПоискКэш.Колонки.Добавить("ПользовательХранилища");
	
	мТЗПоискКэш.Индексы.Добавить("МетаданныеИмя");
КонецПроцедуры //Получить

Функция ПолучитьЗначениеИзКэша(МетаданныеИмя,ПараметрыПоиска) Экспорт
	РезультатФункции = Новый Структура();
	пЗначениеИзКэша = Неопределено;
	ЭтоЗначениеИзКэша = Ложь;	
	ПараметрыОтбора=Новый Структура();
	ПараметрыОтбора.Вставить("МетаданныеИмя",МетаданныеИмя);
	ПараметрыПойскаСтрока = "";
	Для каждого СтрокаПараметрыПоиска из ПараметрыПоиска цикл
		ПараметрыОтбора.Вставить(СтрокаПараметрыПоиска.Ключ,СтрокаПараметрыПоиска.Значение);
		ПараметрыПойскаСтрока = ПараметрыПойскаСтрока + "" +СтрокаПараметрыПоиска.Ключ + " ["+СтрокаПараметрыПоиска.Значение+"]";
	Конеццикла;
	НайденныеСтроки = мТЗПоискКэш.НайтиСтроки(ПараметрыОтбора);
	Если НайденныеСтроки.Количество()=1 тогда
		пЗначениеИзКэша = НайденныеСтроки[0].Ссылка;
		ЭтоЗначениеИзКэша = Истина;
	ИначеЕсли НайденныеСтроки.Количество()>1 Тогда
		Сообщить("Ошибка! Найдено более 1 значения в кэше МетаданныеИмя ["+МетаданныеИмя+"] по указанным параметрам поиска"
			+" "+ПараметрыПойскаСтрока);
	Иначе
		//Сообщить("Не найден ");		
	Конецесли;
	РезультатФункции.Вставить("ЭтоЗначениеИзКэша",ЭтоЗначениеИзКэша);
	РезультатФункции.Вставить("ЗначениеИзКэша",пЗначениеИзКэша);
	Возврат РезультатФункции;	
КонецФункции 

Процедура ДобавитьЗначениеВКэш(СсылкаНаОбъект,МетаданныеИмя,ПараметрыПоиска) Экспорт
	СтрокамТЗПоискКэш = мТЗПоискКэш.Добавить();
	ЗаполнитьЗначенияСвойств(СтрокамТЗПоискКэш,ПараметрыПоиска);
	СтрокамТЗПоискКэш.Ссылка = СсылкаНаОбъект;
	СтрокамТЗПоискКэш.МетаданныеИмя = МетаданныеИмя;
КонецПроцедуры //ДобавитьЗначениеВКэш(Справочники.Модели.ПустаяСсылка(),"Модели",ПараметрыПоиска)

Функция ПолучитьСсылкуНаОбъект(МетаданныеИмя,ПараметрыПоиска) Экспорт 
	пСсылкаНаОбъект = Неопределено;

	РезультатФункции = ПолучитьЗначениеИзКэша(МетаданныеИмя,ПараметрыПоиска);	
	Если РезультатФункции.ЭтоЗначениеИзКэша Тогда
		пСсылкаНаОбъект = РезультатФункции.ЗначениеИзКэша;
		Возврат пСсылкаНаОбъект;
	Конецесли;
	//Если НЕ ЗначениеЗаполнено(ЗначениеДляПоиска) Тогда
	//	ДобавитьЗначениеВКэш(пСсылкаНаОбъект,МетаданныеИмя,ПараметрыПоиска);		
	//	Возврат пСсылкаНаОбъект;
	//Конецесли;
	
	Если МетаданныеИмя = "Пользователи" Тогда
		пСсылкаНаОбъект = узОбщийМодульСервер.ПолучитьПользователяПоПользователюХранилища(ПараметрыПоиска.ПользовательХранилища);		
		ДобавитьЗначениеВКэш(пСсылкаНаОбъект,МетаданныеИмя,ПараметрыПоиска);
	Иначе
		Запрос = Новый Запрос;
		Запрос.Текст = ПолучитьТекстЗапросаДляПоиска(МетаданныеИмя);
		Для каждого ЭлПараметрыПоиска из ПараметрыПоиска цикл
			Запрос.УстановитьПараметр(ЭлПараметрыПоиска.Ключ, ЭлПараметрыПоиска.Значение);		
		Конеццикла;
		
		РезультатЗапроса = Запрос.Выполнить();

		пСсылкаНаОбъект = ПолучитьЗначениеИзЗапроса(РезультатЗапроса,МетаданныеИмя,ПараметрыПоиска);
	Конецесли;
	Возврат пСсылкаНаОбъект;
	
КонецФункции //ПолучитьСсылкуНаОбъект()

Функция ПолучитьТекстЗапросаДляПоиска(МетаданныеИмя) Экспорт 
	ТекстЗапроса = Неопределено;
	Если МетаданныеИмя = "узЗадачи" Тогда
		ТекстЗапроса = "
		|ВЫБРАТЬ
		|	узЗадачи.Ссылка,
		|	узЗадачи.Наименование
		|ИЗ
		|	Справочник.узЗадачи КАК узЗадачи
		|ГДЕ
		|	узЗадачи.Код = &Код	
		|";
	ИначеЕсли МетаданныеИмя = "узИдентификаторыОбъектовМетаданныхКонфигурации" Тогда
		ТекстЗапроса = "ВЫБРАТЬ
		|	узИдентификаторыОбъектовМетаданныхКонфигурации.Ссылка,
		|	узИдентификаторыОбъектовМетаданныхКонфигурации.Наименование
		|ИЗ
		|	Справочник.узИдентификаторыОбъектовМетаданныхКонфигурации КАК узИдентификаторыОбъектовМетаданныхКонфигурации
		|ГДЕ
		|	узИдентификаторыОбъектовМетаданныхКонфигурации.Владелец = &Владелец
		|	И узИдентификаторыОбъектовМетаданныхКонфигурации.Родитель = &Родитель
		|	И узИдентификаторыОбъектовМетаданныхКонфигурации.Наименование ПОДОБНО &Наименование
		|";
	Иначе
		ВызватьИсключение "Ошибка! Нет текста запроса для поиска"+МетаданныеИмя;
	Конецесли;
	Возврат ТекстЗапроса;	
КонецФункции //ПолучитьТекстЗапросаДляПоиска()

Функция ПолучитьЗначениеИзЗапроса(РезультатЗапроса,МетаданныеИмя,ПараметрыПоиска) Экспорт 
	пЗначениеИзЗапроса = Неопределено;
	Выборка = РезультатЗапроса.Выбрать();
	ВыборкаКоличество = Выборка.Количество();
	Если ВыборкаКоличество = 0 Тогда
		пЗначениеИзЗапроса = Неопределено;
		Если МетаданныеИмя = "узИдентификаторыОбъектовМетаданныхКонфигурации" Тогда
			пЗначениеИзЗапроса = Создать_узИдентификаторыОбъектовМетаданныхКонфигурации(ПараметрыПоиска);	
		Конецесли;
		ДобавитьЗначениеВКэш(пЗначениеИзЗапроса,МетаданныеИмя,ПараметрыПоиска);
		Если НЕ ЗначениеЗаполнено(пЗначениеИзЗапроса) Тогда
			ТекстОшибки = "ВНИМАНИЕ! Не найдена "+МетаданныеИмя + Символы.ПС;
			Для каждого ЭлПараметрыПоиска из ПараметрыПоиска цикл
				ТекстОшибки = ТекстОшибки + " - Ключ "+ЭлПараметрыПоиска.Ключ + " Значение ["+ЭлПараметрыПоиска.Значение+"]" + Символы.ПС;
			Конеццикла;
			Сообщить(ТекстОшибки);
		Конецесли;
	ИначеЕсли ВыборкаКоличество > 1 Тогда
		ТекстОшибки = "ВНИМАНИЕ! Найдено более 1 "+МетаданныеИмя + Символы.ПС;
		Для каждого ЭлПараметрыПоиска из ПараметрыПоиска цикл
			ТекстОшибки = ТекстОшибки + " - Ключ "+ЭлПараметрыПоиска.Ключ + " Значение ["+ЭлПараметрыПоиска.Значение+"]" + Символы.ПС;
		Конеццикла;
		Сообщить(ТекстОшибки);
		Пока Выборка.Следующий() Цикл
			ДобавитьЗначениеВКэш(Неопределено,МетаданныеИмя,ПараметрыПоиска);
		КонецЦикла;		
	Иначе
		Выборка.Следующий();
		пЗначениеИзЗапроса = Выборка.Ссылка;
		ДобавитьЗначениеВКэш(пЗначениеИзЗапроса,МетаданныеИмя,ПараметрыПоиска);
	Конецесли;
	Возврат пЗначениеИзЗапроса;
КонецФункции //ПолучитьЗначениеИзЗапроса()

Процедура СохранитьИсториюХранилищаВБД(ТЗИсторияХранилища)
	Для каждого СтрокаТЗИсторияХранилища из ТЗИсторияХранилища цикл
		СпрОбъект = ПолучитьСпрОбъект_узИсторияХранилища(СтрокаТЗИсторияХранилища);
		ЗаполнитьЗначенияСвойств(СпрОбъект,СтрокаТЗИсторияХранилища);
		СпрОбъект.ИзмененныеОбъекты.Очистить();
		Для каждого СтрокаТЗИзмененныеОбъекты из СтрокаТЗИсторияХранилища.ТЗИзмененныеОбъекты цикл
			СтрокаИзмененныеОбъекты=СпрОбъект.ИзмененныеОбъекты.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаИзмененныеОбъекты,СтрокаТЗИзмененныеОбъекты);
		Конеццикла;
		СпрОбъект.Записать();
	Конеццикла;
КонецПроцедуры 

Функция ПолучитьСпрОбъект_узИсторияХранилища(СтрокаТЗИсторияХранилища) 
	Перем СпрОбъект_узИсторияХранилища;	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	узИсторияКонфигураций.Ссылка,
	|	узИсторияКонфигураций.Владелец,
	|	узИсторияКонфигураций.Версия
	|ИЗ
	|	Справочник.узИсторияКонфигураций КАК узИсторияКонфигураций
	|ГДЕ
	|	узИсторияКонфигураций.Владелец = &Владелец
	|	И узИсторияКонфигураций.Версия = &Версия
	|	И НЕ узИсторияКонфигураций.ВводВручную";
	
	Запрос.УстановитьПараметр("Версия", СтрокаТЗИсторияХранилища.Версия);
	Запрос.УстановитьПараметр("Владелец", Конфигурация);
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		СпрОбъект_узИсторияКонфигураций = Справочники.узИсторияКонфигураций.СоздатьЭлемент();
		СпрОбъект_узИсторияКонфигураций.Владелец = Конфигурация;
	Иначе
		Выборка = РезультатЗапроса.Выбрать();
		Выборка.Следующий();
		СпрОбъект_узИсторияКонфигураций = Выборка.Ссылка.ПолучитьОбъект();
	Конецесли;
	Возврат СпрОбъект_узИсторияКонфигураций;
КонецФункции 

Функция ВыгрузитьИзмененияИзХранилища() Экспорт 
	НастройкиЗапускаКонфигуратора = ПолучитьНастройкиЗапускаКонфигуратора();
	ТекстКоманды = НастройкиЗапускаКонфигуратора.ТекстКоманды;
	ФайлВыгрузкиИзменений = НастройкиЗапускаКонфигуратора.ФайлВыгрузкиИзменений;
	
	КодВозврата = ВыполнитьКоманду(ТекстКоманды);	
	Если КодВозврата <> 0 Тогда
		ОписаниеОшибки = "При получении таблицы версий хранилища произошла неизвестная ошибка";
		ВызватьИсключение ИсключениеОшибкаПриВыполненииКоманды(ОписаниеОшибки, ТекстКоманды);
	КонецЕсли;
	Возврат ФайлВыгрузкиИзменений;
КонецФункции 

Функция ПолучитьНастройкиЗапускаКонфигуратора(ФайлВыгрузкиИзменений = Неопределено) Экспорт 
	
	Если ФайлВыгрузкиИзменений = Неопределено Тогда
		ИмяФайлаДляВыгрузки = ПолучитьИмяФайлаДляВыгрузки();
		ФайлВыгрузкиИзменений = КаталогВременныхФайлов() + ИмяФайлаДляВыгрузки;		
	Конецесли;
	
	ТекстКоманды = "";
	
	ТекстКоманды = СоздатьКоманду(Конфигурация.Приложение1с);
	ДобавитьВКомандуКлючЗначение(ТекстКоманды, "/F", Конфигурация.КаталогТранзитнойБазы);
	ДобавитьВКомандуКлючЗначение(ТекстКоманды, "/N", Конфигурация.ПользовательТранзитнойБазы);
	ДобавитьВКомандуКлючЗначение(ТекстКоманды, "/P", Конфигурация.ПарольПользователяВТранзитнуюБазу);
	ДобавитьВКомандуКлючЗначение(ТекстКоманды, "/ConfigurationRepositoryF", Конфигурация.КаталогХранилища);
	ДобавитьВКомандуКлючЗначение(ТекстКоманды, "/ConfigurationRepositoryN", Конфигурация.ПользовательХранилища);
	ДобавитьВКомандуКлючЗначение(ТекстКоманды, "/ConfigurationRepositoryP", Конфигурация.ПарольПользователяВХранилище);
	ДобавитьВКомандуКлючЗначение(ТекстКоманды, "/ConfigurationRepositoryReport", ФайлВыгрузкиИзменений);	
	Если ЗначениеЗаполнено(ВерсияС) Тогда
		ДобавитьВКомандуКлючЗначение(ТекстКоманды, "-NBegin", Формат(ВерсияС, "ЧН=; ЧГ=0")); 
	КонецЕсли;
	Если ЗначениеЗаполнено(ВерсияПо) Тогда
		ДобавитьВКомандуКлючЗначение(ТекстКоманды, "-NEnd", Формат(ВерсияПо, "ЧН=; ЧГ=0")); 
	КонецЕсли;	
	
	ДобавитьВКомандуКлючЗначение(ТекстКоманды, "-GroupByComment"); 	
	
	РезультатФункции = Новый Структура();
	РезультатФункции.Вставить("ТекстКоманды",ТекстКоманды);
	РезультатФункции.Вставить("ФайлВыгрузкиИзменений",ФайлВыгрузкиИзменений);
	РезультатФункции.Вставить("ИмяФайлаДляВыгрузки",ИмяФайлаДляВыгрузки);
	Возврат РезультатФункции;
КонецФункции 

Функция ПолучитьИмяФайлаДляВыгрузки() Экспорт 
	Возврат "StorageHistory_"+Формат(ТекущаяДата(),"ДФ=ddMMyyyy_hhmmss")+".mxl";	
КонецФункции 

Процедура ДобавитьВКомандуКлючЗначение(ТекстКоманды, Ключ, Значение = Неопределено)
	
	Если Значение = Неопределено Тогда
		ТекстКоманды = ТекстКоманды + " " + Ключ;
	Иначе	
		ТекстКоманды = ТекстКоманды + " " + Ключ + " """ + Экранировать(Значение) + """";
	КонецЕсли;
		
КонецПроцедуры

Функция Экранировать(Значение)
	
	Возврат СтрЗаменить(Значение, """", """""");	
	
КонецФункции

Функция СоздатьКоманду(Приложение)
	
	ТекстКоманды = """" + Приложение + """" + " DESIGNER ";
	Возврат ТекстКоманды;
	
КонецФункции

Функция ВыполнитьКоманду(ТекстКоманды)
	КодВозврата = Неопределено;
	ЗапуститьПриложение(ТекстКоманды,, Истина, КодВозврата);
	Возврат КодВозврата;
	
КонецФункции

Функция ИсключениеОшибкаПриВыполненииКоманды(ОписаниеОшибки, ТекстКоманды)
	
	Возврат ОписаниеОшибки + "(" + ТекстКоманды + ")";	
	
КонецФункции

Функция ПолучитьТЗИсторияХранилища(ТабДокИсторияХранилища)
		
	ТЗИсторияХранилища = Новый ТаблицаЗначений;
	ТЗИсторияХранилища.Колонки.Добавить("Версия", Новый ОписаниеТипов("Число"));
	ТЗИсторияХранилища.Колонки.Добавить("ДатаВерсии", Новый ОписаниеТипов("Дата"));
	ТЗИсторияХранилища.Колонки.Добавить("ПользовательХранилища", Новый ОписаниеТипов("Строка"));
	ТЗИсторияХранилища.Колонки.Добавить("Пользователь", Новый ОписаниеТипов("СправочникСсылка.Пользователи"));
	ТЗИсторияХранилища.Колонки.Добавить("Комментарий", Новый ОписаниеТипов("Строка"));
	ТЗИсторияХранилища.Колонки.Добавить("Задача", Новый ОписаниеТипов("СправочникСсылка.узЗадачи"));
	ТЗИсторияХранилища.Колонки.Добавить("ТЗИзмененныеОбъекты");
	
	
	ИмяПоля_Версия = "Версия:";
	ИмяПоля_Пользователь = "Пользователь:";
	ИмяПоля_ДатаСоздания = "Дата создания:";
	ИмяПоля_ВремяСоздания = "Время создания:";
	ИмяПоля_Комментарий = "Комментарий:";
	ИмяПоля_Добавлены = "Добавлены:";
	ИмяПоля_Изменены = "Изменены:";
	ИмяПоля_Удалены = "Удалены:";
	
	ВидыИзменений_Добавлен = ПредопределенноеЗначение("Перечисление.узВидыИзменений.Добавлен");
	ВидыИзменений_Удален = ПредопределенноеЗначение("Перечисление.узВидыИзменений.Удален");
	ВидыИзменений_Изменен = ПредопределенноеЗначение("Перечисление.узВидыИзменений.Изменен");
	
	
	Ряд = 0;
	пДатаВерсии = Неопределено;
	ТекстДатаСоздания = Неопределено;
	ТекущийВидИзменения = Неопределено;
	Пока ТабДокИсторияХранилища.ВысотаТаблицы >= Ряд Цикл
		Ряд = Ряд + 1;
		
		ЗначениеЯчейкиКолонка1 = СокрЛП(ТабДокИсторияХранилища.Область(Ряд,1).Текст);
		ЗначениеЯчейкиКолонка2 = СокрЛП(ТабДокИсторияХранилища.Область(Ряд,2).Текст);
		Если ТекущийВидИзменения = Неопределено 
			И НЕ ЗначениеЗаполнено(ЗначениеЯчейкиКолонка1) Тогда
			Продолжить;
		Конецесли;
		Если ВЗначенииЯчейкиЕстьПодстрока(ЗначениеЯчейкиКолонка1,ИмяПоля_Версия) Тогда
			пДатаВерсии = Неопределено;
			ТекстДатаСоздания = Неопределено;
			ТекущийВидИзменения = Неопределено;
			
			ТЗИзмененныеОбъекты = Новый ТаблицаЗначений;
			ТЗИзмененныеОбъекты.Колонки.Добавить("ВидИзменения",Новый ОписаниеТипов("ПеречислениеСсылка.узВидыИзменений"));
			ТЗИзмененныеОбъекты.Колонки.Добавить("ТекстИдентификатораОбъектаМетаданных",Новый ОписаниеТипов("Строка"));
			ТЗИзмененныеОбъекты.Колонки.Добавить("ИдентификаторОбъектаМетаданных",Новый ОписаниеТипов("СправочникСсылка.узИдентификаторыОбъектовМетаданныхКонфигурации"));
			
			СтрокаТЗИсторияХранилища = ТЗИсторияХранилища.Добавить();
			СтрокаТЗИсторияХранилища.Версия = Число(ЗначениеЯчейкиКолонка2);
			СтрокаТЗИсторияХранилища.ТЗИзмененныеОбъекты = ТЗИзмененныеОбъекты;
			Продолжить;
		Конецесли;
		Если ВЗначенииЯчейкиЕстьПодстрока(ЗначениеЯчейкиКолонка1,ИмяПоля_Пользователь) Тогда
			СтрокаТЗИсторияХранилища.ПользовательХранилища = ЗначениеЯчейкиКолонка2;
			Продолжить;
		Конецесли;		
		
		Если ВЗначенииЯчейкиЕстьПодстрока(ЗначениеЯчейкиКолонка1,ИмяПоля_ДатаСоздания) Тогда
			ТекстДатаСоздания = ЗначениеЯчейкиКолонка2;
			Продолжить;
		Конецесли;	
		Если ВЗначенииЯчейкиЕстьПодстрока(ЗначениеЯчейкиКолонка1,ИмяПоля_ВремяСоздания) Тогда
			ТекстВремяСоздания = ЗначениеЯчейкиКолонка2;
			пДатаВерсии = Неопределено;
			пДатаВерсии = Дата(ТекстДатаСоздания +" " +ТекстВремяСоздания);
			СтрокаТЗИсторияХранилища.ДатаВерсии = пДатаВерсии;
			Продолжить;
		Конецесли;			
		Если ВЗначенииЯчейкиЕстьПодстрока(ЗначениеЯчейкиКолонка1,ИмяПоля_Комментарий) Тогда
			СтрокаТЗИсторияХранилища.Комментарий = ЗначениеЯчейкиКолонка2;			
			Продолжить;
		Конецесли;
		
		
		Если ВЗначенииЯчейкиЕстьПодстрока(ЗначениеЯчейкиКолонка1,ИмяПоля_Добавлены) Тогда
			ТекущийВидИзменения = ВидыИзменений_Добавлен;
		Конецесли;
		Если ВЗначенииЯчейкиЕстьПодстрока(ЗначениеЯчейкиКолонка1,ИмяПоля_Изменены) Тогда
			ТекущийВидИзменения = ВидыИзменений_Изменен;
		Конецесли;		
		Если ВЗначенииЯчейкиЕстьПодстрока(ЗначениеЯчейкиКолонка1,ИмяПоля_Удалены) Тогда
			ТекущийВидИзменения = ВидыИзменений_Удален;
		Конецесли;			
		
		Если ТекущийВидИзменения <> Неопределено
			И ЗначениеЗаполнено(ЗначениеЯчейкиКолонка2) Тогда
			ДобавитьВТЗИзмененныеОбъекты(ТЗИзмененныеОбъекты,ТекущийВидИзменения,ЗначениеЯчейкиКолонка2);
			Продолжить;
		Конецесли;
	КонецЦикла;
	Возврат ТЗИсторияХранилища;
КонецФункции

Функция ПолучитьПользователя(СтрокаТЗИсторияХранилища) 
	Перем пПользователь;
	
	пПользовательХранилища = СокрЛП(СтрокаТЗИсторияХранилища.ПользовательХранилища);
	
	Если НЕ ЗначениеЗаполнено(пПользовательХранилища) Тогда
		ТекстОшибки = "Ошибка! Не заполнен пользователь в хранилище";
		Возврат пПользователь;	
	Конецесли;
	
	ПараметрыПоиска = Новый Структура();
	ПараметрыПоиска.Вставить("ПользовательХранилища",пПользовательХранилища);
	пПользователь = ПолучитьСсылкуНаОбъект("Пользователи",ПараметрыПоиска);
	
	Возврат пПользователь;
	
КонецФункции 

Функция ПолучитьЗадачу(СтрокаТЗИсторияХранилища) 
	Перем пЗадача;
	пКомментарий = СокрЛП(СтрокаТЗИсторияХранилища.Комментарий);
	
	Если НЕ ЗначениеЗаполнено(пКомментарий) Тогда
		ТекстОшибки = "Ошибка! Не заполнен комментарий в хранилище";
		ОтправитьУведомлениеОшибкаВКомментарииХранилища(ТекстОшибки,СтрокаТЗИсторияХранилища);
		Возврат пЗадача;	
	Конецесли;
	
	ПозРешетки = СтрНайти(пКомментарий,"#");
	Если ПозРешетки = 0 Тогда
		ТекстОшибки = "Ошибка! В комментарии не указан номер задачи. Необходимо указать #НомерЗадачи";
		ОтправитьУведомлениеОшибкаВКомментарииХранилища(ТекстОшибки,СтрокаТЗИсторияХранилища);
		Возврат пЗадача;	
	Конецесли;
	
	КоличествоУказанныхЗадач = СтрЧислоВхождений(пКомментарий,"#");
	Если КоличествоУказанныхЗадач > 1 Тогда
		ТекстОшибки = "Ошибка! В комментарии можно указывать только один номер задачи. В будущем всегда разбивайте помещения объектов в хранилище на отдельные задачи.";
		ОтправитьУведомлениеОшибкаВКомментарииХранилища(ТекстОшибки,СтрокаТЗИсторияХранилища);
		Возврат пЗадача;	
	Конецесли;	
	
	ДлинаСтроки = СтрДлина(пКомментарий);
	НомерСимвола = ПозРешетки + 1;
	НомерЗадачи = "";
	Пока НомерСимвола <= ДлинаСтроки Цикл
		Символ = Сред(пКомментарий,НомерСимвола,1);
		пКодСимвола = КодСимвола(Символ);
		Если 48 <= пКодСимвола
			И пКодСимвола <= 57 Тогда
			НомерЗадачи = НомерЗадачи + Символ;
		Иначе
			Прервать;
		Конецесли;
		НомерСимвола = НомерСимвола + 1;
	Конеццикла;
	
	Если НЕ ЗначениеЗаполнено(НомерЗадачи) Тогда
		Возврат пЗадача;	
	Конецесли;
	
	НомерЗадачи = Число(НомерЗадачи);
	ПараметрыПоиска = Новый Структура();
	ПараметрыПоиска.Вставить("Код",НомерЗадачи);
	пЗадача = ПолучитьСсылкуНаОбъект("узЗадачи",ПараметрыПоиска);
	
	Возврат пЗадача;
КонецФункции 

Процедура ОтправитьУведомлениеОшибкаВКомментарииХранилища(ТекстОшибки,СтрокаТЗИсторияХранилища)
	
	пПользовательКому = СтрокаТЗИсторияХранилища.Пользователь;
	Если НЕ ЗначениеЗаполнено(пПользовательКому) Тогда
		пПользовательКому = узОбщийМодульСервер.ПолучитьПользователяПоПользователюХранилища(СтрокаТЗИсторияХранилища.ПользовательХранилища);
	Конецесли;
	
	МассивПользователейКому = Новый Массив();	
	Если ЗначениеЗаполнено(пПользовательКому) Тогда
		МассивПользователейКому.Добавить(пПользовательКому);
	Конецесли;
	
	Для каждого ЭлМассиваПользователейКомуОтправлятьСистемныеУведомления из мМассивПользователейКомуОтправлятьСистемныеУведомления цикл
		Если МассивПользователейКому.Найти(ЭлМассиваПользователейКомуОтправлятьСистемныеУведомления) <> Неопределено Тогда
			Продолжить;
		Конецесли;
		МассивПользователейКому.Добавить(ЭлМассиваПользователейКомуОтправлятьСистемныеУведомления);
	Конеццикла;
	
	Если МассивПользователейКому.Количество() = 0 Тогда
		Возврат;
	Конецесли;
	
	пТемаПисьма = ТекстОшибки;
	
	пТекстПисьма = пТемаПисьма +"		
		| версия ["+СтрокаТЗИсторияХранилища.Версия+"]
		| ДатаВерсии ["+СтрокаТЗИсторияХранилища.ДатаВерсии+"]
		| ПользовательХранилища ["+СтрокаТЗИсторияХранилища.ПользовательХранилища+"]
		| Комментарий ["+СтрокаТЗИсторияХранилища.Комментарий+"]";	
	
	ДопПараметры = Новый Структура();
	ДопПараметры.Вставить("ВажностьЗадачи",Перечисления.ВариантыВажностиЗадачи.Высокая);
	ДопПараметры.Вставить("ТекстПисьма",пТекстПисьма);
	ДопПараметры.Вставить("ТемаПисьма",пТемаПисьма);
	ДопПараметры.Вставить("МассивПользователейКому",МассивПользователейКому);
	узОбщийМодульСервер.ОтправитьПисьмо(ДопПараметры);
	
КонецПроцедуры 

Функция ПолучитьИдентификаторОбъектаМетаданныхПоСтроке(ПолноеИмяМетаданных) Экспорт 
	Перем пИдентификаторОбъектаМетаданных;
	
	ПолноеИмяМетаданных = СокрЛП(ПолноеИмяМетаданных);	
	
	ДобавитьРодителяВПолноеИмяМетаданных(ПолноеИмяМетаданных);
	
	пРодитель = ПредопределенноеЗначение("Справочник.узИдентификаторыОбъектовМетаданныхКонфигурации.ПустаяСсылка");
	НеОбработаннаяСтрока = ПолноеИмяМетаданных;
	Пока НеОбработаннаяСтрока <> "" Цикл
		
		ПозТочки = СтрНайти(НеОбработаннаяСтрока,".");	
		Если ПозТочки = 0 Тогда
			пИмяМетаданных = НеОбработаннаяСтрока;
		Иначе
			пИмяМетаданных = Лев(НеОбработаннаяСтрока,ПозТочки - 1);
		Конецесли;
		
		Если пИдентификаторОбъектаМетаданных <> Неопределено Тогда
			пРодитель = пИдентификаторОбъектаМетаданных;
		Конецесли;
		
		ПараметрыПоиска = Новый Структура();
		ПараметрыПоиска.Вставить("Владелец",Конфигурация);	
		ПараметрыПоиска.Вставить("Наименование",пИмяМетаданных);	
		ПараметрыПоиска.Вставить("Родитель",пРодитель);			
		пИдентификаторОбъектаМетаданных = ПолучитьСсылкуНаОбъект("узИдентификаторыОбъектовМетаданныхКонфигурации",ПараметрыПоиска);		
		
		НеОбработаннаяСтрока = Сред(НеОбработаннаяСтрока,ПозТочки+1);
		Если ПозТочки = 0 Тогда
			НеОбработаннаяСтрока = "";
			Прервать;
		Конецесли;
	Конеццикла;
	
	Возврат пИдентификаторОбъектаМетаданных;	
КонецФункции 

Процедура ДобавитьРодителяВПолноеИмяМетаданных(ПолноеИмяМетаданных)
	
	ПозТочки = СтрНайти(ПолноеИмяМетаданных,".");	
	пИмяМетаданных = Лев(ПолноеИмяМетаданных,ПозТочки - 1);
	РезультатФункции = ПолучитьСвойствоМетаданных(пИмяМетаданных);	
	Если РезультатФункции.Родитель <> Неопределено Тогда
		ПолноеИмяМетаданных = РезультатФункции.Родитель+"."+ПолноеИмяМетаданных;		
	КонецЕсли;
КонецПроцедуры 

Функция Создать_узИдентификаторыОбъектовМетаданныхКонфигурации(ПараметрыПоиска) 
	Перем ИмяМетаданныхРодителя;
	
	Если СтрДлина(ПараметрыПоиска.Наименование) > 150 Тогда
		ВызватьИсключение "Ошибка! нет алгоритма поиска идентификатора объекта метаданных, у которых наименование больше 150 символов";
	Конецесли;
	пИдентификаторыОбъектовМетаданных = Неопределено;
	
	СпрОбъект = Справочники.узИдентификаторыОбъектовМетаданныхКонфигурации.СоздатьЭлемент();
	СпрОбъект.Владелец = ПараметрыПоиска.Владелец;
	СпрОбъект.Наименование = ПараметрыПоиска.Наименование;
	СпрОбъект.Родитель = ПараметрыПоиска.Родитель; 
	
	пПолноеИмяМетаданных = СпрОбъект.ПолноеНаименование();
	пПолноеИмяМетаданных = СтрЗаменить(пПолноеИмяМетаданных,"/",".");
	СпрОбъект.ПолноеИмяМетаданных = пПолноеИмяМетаданных;	
	РезультатФункции = ПолучитьСвойствоМетаданных(СпрОбъект.Наименование);
	СпрОбъект.ИмяМетаданных = ПараметрыПоиска.Наименование;
	СпрОбъект.ПорядокКоллекции = РезультатФункции.ПорядокКоллекции; 
	СпрОбъект.Записать();
	пИдентификаторыОбъектовМетаданных = СпрОбъект.Ссылка; 
	Возврат пИдентификаторыОбъектовМетаданных;
КонецФункции

Функция ПолучитьСвойствоМетаданных(Имя) 
	
	пРодитель = Неопределено;
	пПорядокКоллекции = 0;
	ПараметрыОтбора=Новый Структура();
	ПараметрыОтбора.Вставить("Имя",Имя);
	НайденныеСтроки = мТЗСвойстваМетаданных.НайтиСтроки(ПараметрыОтбора);
	ВсегоНайденныеСтроки = НайденныеСтроки.Количество();
	ТекстОшибки = "";
	Если ВсегоНайденныеСтроки = 1 тогда
		СтрокамТЗСвойстваМетаданных = НайденныеСтроки[0];	
		пПорядокКоллекции = СтрокамТЗСвойстваМетаданных.ПорядокКоллекции;
		Если ЗначениеЗаполнено(СтрокамТЗСвойстваМетаданных.Родитель) Тогда
			пРодитель = СтрокамТЗСвойстваМетаданных.Родитель; 
		Конецесли;
	ИначеЕсли ВсегоНайденныеСтроки > 1 Тогда
		ТекстОшибки = "Ошибка! Найдено более 1 строки установлен пПорядокКоллекции = 0";
		пПорядокКоллекции = 0;		
	Иначе
		//ТекстОшибки = "Ошибка! Не найдена строка будет установлен пПорядокКоллекции = 0";
		пПорядокКоллекции = 0;
	Конецесли;
	
	Если ЗначениеЗаполнено(ТекстОшибки) Тогда
		ТекстОшибки = ТекстОшибки  
			+" в ""мТЗСвойстваМетаданных"" для ";
		Для каждого ЭлементОтбора из ПараметрыОтбора цикл
			ТекстОшибки = ТекстОшибки  
				+" "+ ЭлементОтбора.Ключ + " = "+ЭлементОтбора.Значение;				
		Конеццикла;
		Сообщить(ТекстОшибки);	
	Конецесли;
	
	РезультатФункции = Новый Структура();
	РезультатФункции.Вставить("ПорядокКоллекции",пПорядокКоллекции);
	РезультатФункции.Вставить("Родитель",пРодитель);
	
	Возврат РезультатФункции;	
КонецФункции 

Процедура ДобавитьВТЗИзмененныеОбъекты(ТЗИзмененныеОбъекты,ЗНАЧ ВидИзменения,ТекстИдентификатораОбъектаМетаданных)
	СтрокаТЗИзмененныеОбъекты = ТЗИзмененныеОбъекты.Добавить();
	СтрокаТЗИзмененныеОбъекты.ВидИзменения = ВидИзменения;
	СтрокаТЗИзмененныеОбъекты.ТекстИдентификатораОбъектаМетаданных = ТекстИдентификатораОбъектаМетаданных;	
КонецПроцедуры 

Функция ВЗначенииЯчейкиЕстьПодстрока(ЗначениеЯчейки,ПодстрокаПоиска) 
	Возврат СтрНайти(НРЕГ(ЗначениеЯчейки),НРЕГ(ПодстрокаПоиска))>0;	
КонецФункции 

Функция ПолучитьТекстКоманды() Экспорт
	НастройкиЗапускаКонфигуратора = ПолучитьНастройкиЗапускаКонфигуратора();
	ТекстКоманды = НастройкиЗапускаКонфигуратора.ТекстКоманды;
	Сообщить(ТекстКоманды);
Конецфункции


мМассивПользователейКомуОтправлятьСистемныеУведомления = Справочники.узКонстанты.ПолучитьМассивЗначенийКонстанты("СписокПользователейКомуОтправлятьСистемныеУведомления"
	,Тип("СправочникСсылка.Пользователи"),,Ложь,Ложь);