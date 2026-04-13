# CSCI3100 Group11 Project

## Group Member:

| SID        | Name              | GitHub         |
| ---------- | ----------------- | -------------- |
| 1155224394 | LEI Leok          | alfredlei9     |
| 1155233822 | Chan Tsz Hong     | ThisUserName66 |
| 1155212071 | Wong King Hei     | PreQ1n         |
| 1155212129 | Lam Sau Ha        | hahalam204     |
| 1155248953 | CHEUNG Cho Cheung | JoeCheung11    |

## Selected Topic:

Option A - CUHK Venue & Equipment Booking SaaS

---

# Setup Guide:

## Prerequisites:

Ensure you have the following installed:

- Ruby `3.3.10`
- Rails `8.1.3`
- SQLite3
- Bundler (`gem install bundler`)

**1. Clone the repository**

```bash
git clone https://github.com/PreQ1n/CSCI-3100-Software-Engineering.git
cd CSCI-3100-Software-Engineering
```

**2. Install dependencies**

```bash
bundle install
```

**3. Configure environment variables**

```bash
cp .env.example .env
```

Edit `.env` and fill in the required values which included in `Blackboard Submission`

**4. Set up the database**

```bash
bundle exec rails db:reset
```

**5. Run the SaaS**

```bash
bundle exec rails s
```

Visit `http://localhost:3000` in your browser.

## Running Tests:

**RSpec(Unit tests):**

```bash
bundle exec rspec
```

**Cucumber(Acceptance tests):**

```bash
bundle exec cucumber
```

---

## List of Implemented Features & Feature Ownership:

| Feature Name                                   | Primary Developer | Secondary Developer | Tertiary Developer | Notes/ Remarks                                      |
| ---------------------------------------------- | ----------------- | ------------------- | ------------------ | --------------------------------------------------- |
| User Auth & Roles                              | Wong King Hei     | x                   | x                  | x                                                   |
| Search Function                                | Lam Sau Ha        | x                   | x                  | x                                                   |
| Venue & Equipment Booking & Conflict Detection | CHEUNG Cho Cheung | LEI Leok            | Chan Tsz Hong      | Prevent double booking in Database Layer & UI Layer |
| Map Integration                                | LEI Leok          | x                   | x                  | Uses Google Map API                                 |
| Email Service                                  | CHEUNG Cho Cheung | x                   | x                  | Uses Brevo API                                      |
| Analytic                                       | Chan Tsz Hong     | x                   | x                  | x                                                   |
| UI/ UX                                         | Chan Tsz Hong     | x                   | x                  | x                                                   |
