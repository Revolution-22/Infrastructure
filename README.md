# Dokument Wizji Projektu "Revolution"

## 1. Wprowadzenie
Dokument ten dotyczy projektu inżynierskiego oraz petproject o nazwie "Revolution". Jest to platforma sprzedażowa wzorowana na popularnych serwisach takich jak Allegro czy OLX. Projekt opiera się na architekturze mikroserwisowej z backendem zaimplementowanym w Spring, frontendem w Angularze oraz aplikacją mobilną w React Native.

## 2. Cel Projektu
Celem projektu jest stworzenie nowoczesnej platformy sprzedażowej, która umożliwi użytkownikom kupowanie i sprzedawanie przedmiotów w internecie w sposób prosty, szybki i bezpieczny.

## 3. Grupa docelowa
Serwis "Revolution" jest skierowany do użytkowników indywidualnych oraz małych firm, które chcą sprzedawać i kupować produkty online.

## 4. Opis Techniczny
### 4.1 Gateway
- Główna brama do mikroserwisów ukrytych w kontenerach Dockerowych.
- Autoryzacja użytkowników poprzez komunikację z AuthService.

### 4.2 DiscoveryService
- Serwer Eureka z funkcjonalnością load balancera zapewniający komunikację między mikroserwisami.

### 4.3 ConfigService
- Centralny serwer konfiguracji zarządzający ustawieniami dla poszczególnych mikroserwisów.

### 4.4 AuthService
- Logowanie i rejestracja użytkowników.
- Walidacja tokenów dostępowych.
- Odświeżanie tokenów.

### 4.5 WalletService
- Zarządzanie stanem konta użytkownika:
    - Automatyczne tworzenie portfela przy rejestracji (wartość początkowa: 0).
- Wpłaty i wypłaty środków:
    - Automatyczne wpłaty po zakupie (obsługiwane eventy z PaymentService).
    - Wypłaty na zweryfikowane konto bankowe.

### 4.6 DetailsService
- Zarządzanie danymi adresowymi użytkownika:
    - Tworzenie danych na podstawie eventów z AuthService.
    - Uzupełnienie danych przez użytkownika na froncie.
- CRUD danych adresowych.

### 4.7 RankService
- Zarządzanie rankingami i opiniami użytkowników:
    - Domyślnie brak ocen przy rejestracji (tworzone eventy z AuthService).
    - Możliwość dodawania komentarzy i opinii po zakupach (wywołania z frontendu po zakupie, eventy z OrderService).
- CRUD rankingów, komentarzy i opinii.

### 4.8 ProductService
- Zarządzanie kategoriami i produktami:
    - CRUD kategorii i produktów.
    - Aktualizacja danych o produktach na podstawie eventów z OrderService (przy statusie "zakończone").

### 4.9 OrderService
- System zamówień:
    - Tworzenie zamówień i zwracanie ich identyfikatorów do frontendu.
    - Obsługa eventów potwierdzających płatność w celu zatwierdzenia zamówienia.
    - Zwracanie statusu zamówienia.
- Integracja z dostawcami usług wysyłkowych.

### 4.10 PaymentService
- Obsługa płatności za zamówienia:
    - Realizacja płatności na podstawie ID zamówienia.
- Integracja z dostawcami usług płatniczych.

### 4.11 NotificationsService
- Generowanie powiadomień:
    - Powiadomienia e-mail (web): odbieranie eventów z OrderService, PaymentService, AuthService, RankService.
    - Powiadomienia push (mobile): obsługa eventów z tych samych źródeł.

## 5. Funkcjonalności Kluczowe
1. **Rejestracja i logowanie:**
    - Możliwość utworzenia konta i logowania się do serwisu.
2. **Obsługa portfela użytkownika:**
    - Zarządzanie stanem konta, wpłaty i wypłaty środków.
3. **Dodawanie i przeglądanie produktów:**
    - Możliwość wystawiania produktów na sprzedaż i przeglądania dostępnych ofert.
4. **System zamówień i płatności:**
    - Realizacja zakupów i obsługa transakcji płatniczych.
5. **Komentarze i rankingi:**
    - Dodawanie opinii po zakupach, możliwość oceny użytkowników.
6. **Powiadomienia:**
    - Automatyczne powiadomienia e-mail oraz push dla użytkowników.

## 6. Podsumowanie
Projekt "Revolution" ma na celu dostarczenie kompleksowej platformy sprzedażowej opartej na nowoczesnych technologiach. Jego modularna budowa zapewnia skalowalność, łatwość rozwoju oraz integracji z zewnętrznymi dostawcami usług.

