# Dokument Techniczny Projektu "Revolution"

## 1. Opis Techniczny
### 1.1 Gateway
- Główna brama do mikroserwisów ukrytych w kontenerach Dockerowych.
- Autoryzacja użytkowników poprzez komunikację z AuthService.

### 1.2 DiscoveryService
- Serwer Eureka z funkcjonalnością load balancera zapewniający komunikację między mikroserwisami.

### 1.3 ConfigService
- Centralny serwer konfiguracji zarządzający ustawieniami dla poszczególnych mikroserwisów.
- UPDATE 25.01.2025 Zamieniono na vault

### 1.4 AuthService
- Logowanie i rejestracja użytkowników.
- Walidacja tokenów dostępowych.
- Odświeżanie tokenów.

### 1.5 WalletService
- Zarządzanie stanem konta użytkownika:
    - Automatyczne tworzenie portfela przy rejestracji (wartość początkowa: 0).
- Wpłaty i wypłaty środków:
    - Automatyczne wpłaty po zakupie (obsługiwane eventy z PaymentService).
    - Wypłaty na zweryfikowane konto bankowe.

### 1.6 DetailsService
- Zarządzanie danymi adresowymi użytkownika:
    - Tworzenie danych na podstawie eventów z AuthService.
    - Uzupełnienie danych przez użytkownika na froncie.
- CRUD danych adresowych.

### 1.7 RankService
- Zarządzanie rankingami i opiniami użytkowników:
    - Domyślnie brak ocen przy rejestracji (tworzone eventy z AuthService).
    - Możliwość dodawania komentarzy i opinii po zakupach (wywołania z frontendu po zakupie, eventy z OrderService).
- CRUD rankingów, komentarzy i opinii.

### 1.8 ProductService
- Zarządzanie kategoriami i produktami:
    - CRUD kategorii i produktów.
    - Aktualizacja danych o produktach na podstawie eventów z OrderService (przy statusie "zakończone").

### 1.9 OrderService
- System zamówień:
    - Tworzenie zamówień i zwracanie ich identyfikatorów do frontendu.
    - Obsługa eventów potwierdzających płatność w celu zatwierdzenia zamówienia.
    - Zwracanie statusu zamówienia.
- Integracja z dostawcami usług wysyłkowych.
- UPDATE 01.04.2025 Wysylanie eventu na kafke po odebraniu zamowienia przez klienta

### 1.10 PaymentService
- Obsługa płatności za zamówienia:
    - Realizacja płatności na podstawie ID zamówienia.
- Integracja z dostawcami usług płatniczych.
- UPDATE 01.04.2025 Odebranie eventu o zrealizowaniu zamowienia (Odbior paczki) i wyplacenie gotowki
- UPDATE 01.10.2025 Emitownie eventu do admin service o zleceniu wyplaty


### 1.11 NotificationsService
- Generowanie powiadomień:
    - Powiadomienia e-mail (web): odbieranie eventów z OrderService, PaymentService, AuthService, RankService.
    - Powiadomienia push (mobile): obsługa eventów z tych samych źródeł.
  
### 1.12 AdminService
- Zadania administracyjne na uzytykownikach:
- Zatwierdzanie wyplat
       - Odbiera event z payment service i robi zlecenie wyplaty oraz emituje event z powiadomieniem
