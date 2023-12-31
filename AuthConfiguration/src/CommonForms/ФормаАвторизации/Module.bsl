#Область ОписаниеПеременных
&НаКлиенте
Перем АвторизацияУспешна;

&НаКлиенте
Перем СчетчикОшибок;

&НаКлиенте
Перем КоличествоСекундСчетчик;
#КонецОбласти

#Область ОбработчикиСобытийФормы
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	WSHShell = Новый COMОбъект("WScript.Shell");
	WSHShell.SendKeys("% ");
	WSHShell.SendKeys("{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}");
	
	АвторизацияУспешна = Ложь;
	СчетчикОшибок = 0;
	Элементы.ГруппаКапча.Видимость = Ложь;
	Элементы.ГруппаБлокировка.Видимость = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	Если АвторизацияУспешна = Ложь Тогда
		ЗавершитьРаботуСистемы();
	Иначе
		Закрыть();
	КонецЕсли;
КонецПроцедуры
#КонецОбласти

#Область ОбработчикиКомандФормы
&НаКлиенте
Процедура Вход(Команда)
	Если СчетчикОшибок = 5 Тогда
		СчетчикОшибок = 0;
		ОбработкаКапчи();
	Иначе
		ОбработкаВхода();		
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьСкрытьПароль(Команда)
	Если Элементы.Пароль.РежимПароля = Истина Тогда
		Элементы.Пароль.РежимПароля = Ложь;
		Элементы.ПоказатьСкрытьПароль.Картинка = БиблиотекаКартинок.СкрытьПароль;
	Иначе
		Элементы.Пароль.РежимПароля = Истина;
		Элементы.ПоказатьСкрытьПароль.Картинка = БиблиотекаКартинок.ПоказатьПароль;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОтменаКапча(Команда)
	Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура ПодтвердитьКапчу(Команда)
	Если  Элементы.Капча.Заголовок = ВводКапчи тогда
		Элементы.ГруппаКапча.Видимость = Ложь;
		Элементы.ГруппаРеквизиты.Видимость = Истина;
		Элементы.ГруппаКоманды.Видимость = Истина;
	Иначе
		ОбработкаКапчи();
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
&НаКлиенте
Процедура ОбработкаВхода()
	Если Не ЗначениеЗаполнено(Логин) или Не ЗначениеЗаполнено(Пароль) Тогда
		ОбработкаОшибки("Введите данные");
	Иначе
		ТекущийПользователь = НайтиТекущегоПользователя(Логин);
		Если ТекущийПользователь = Неопределено Тогда
			ОбработкаОшибки("Такого пользователя не существует");
		Иначе
			Если Пароль = ТекущийПользователь.Пароль Тогда
				Если ТекущийПользователь.Недействительный = Истина Тогда
					ОбработкаБлокировки();
				Иначе
					АвторизацияУспешна = Истина;	
					Закрыть();				
				КонецЕсли;
			Иначе
				ОбработкаОшибки("Пароль неверный");
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция НайтиТекущегоПользователя(Параметры)
	ТекущийПользователь = Справочники.Пользователи.ПоискТекущегоПользователя(Логин);
	
	Если ЗначениеЗаполнено(ТекущийПользователь) Тогда
		Возврат ТекущийПользователь;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
КонецФункции

&НаСервере
Процедура ОбработкаКапчи()
	ВводКапчи = "";
	Элементы.ОшибкаДекор.Заголовок = "";
	Элементы.ГруппаКапча.Видимость = Истина;
	Элементы.ГруппаРеквизиты.Видимость = Ложь;
	Элементы.ГруппаКоманды.Видимость = Ложь;
	СтрокаКапча = МодульГенерацииСлучайныхСтрок.ГенерацияСлучайнойСтрокиИзЦифр();
	Элементы.Капча.Заголовок = СтрокаКапча;
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОшибки(Ошибка)
	СчетчикОшибок = СчетчикОшибок + 1;
	Элементы.ОшибкаДекор.Заголовок = Ошибка;
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаБлокировки()
	Элементы.ГруппаОбщая.Видимость = Ложь;
	Элементы.ГруппаБлокировка.Видимость = Истина;
	КоличествоСекундСчетчик = 10;
	ПодключитьОбработчикОжидания("Ожидание", 1);
КонецПроцедуры

&НаКлиенте
Процедура Ожидание()
	Если КоличествоСекундСчетчик = 0 Тогда
		ОтключитьОбработчикОжидания("Ожидание");
		ЗавершитьРаботуСистемы();
	Иначе
		КоличествоСекундСчетчик = КоличествоСекундСчетчик - 1;
		Элементы.Счетчик.Заголовок = КоличествоСекундСчетчик;
	КонецЕсли;
КонецПроцедуры
#КонецОбласти