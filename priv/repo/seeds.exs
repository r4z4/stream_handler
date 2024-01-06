# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     StreamHandler.Repo.insert!(%StreamHandler.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     EmerPhx.Repo.insert!(%EmerPhx.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

# 8d04fd4f-1321-4e9f-911a-7369d57d0b55

password = System.fetch_env!("USER_PASSWORD")

alias StreamHandler.Repo
alias StreamHandler.Account.User
alias StreamHandler.Streams.UserScore
alias StreamHandler.Streams.UserScoreJson

Repo.insert_all(User, [
      %{slug: "a9f44567-e031-44f1-aae6-972d7aabbb45", username: "admin", email: "admin@admin.com", role: :admin, hashed_password: Bcrypt.hash_pwd_salt(password), confirmed_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{slug: "b5f44567-e031-44f1-aae6-972d7aabbb45", username: "jimbo", email: "jimbo@jimbo.com", role: :subadmin, hashed_password: Bcrypt.hash_pwd_salt(password), confirmed_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{slug: "df18d5eb-e99e-4481-9e16-4d2f434a3711", username: "aaron", email: "aaron@aaron.com", role: :subadmin, hashed_password: Bcrypt.hash_pwd_salt(password), confirmed_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{slug: "67bbf29b-7ee9-48a4-b2fb-9a113e26ac91", username: "mn_user", email: "mn_user@example.com", role: :reader, hashed_password: Bcrypt.hash_pwd_salt(password), confirmed_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{slug: "459180af-49aa-48df-92e2-547be9283ac4", username: "wi_user", email: "wi_user@example.com", role: :reader, hashed_password: Bcrypt.hash_pwd_salt(password), confirmed_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{slug: "cf1ffc43-58a2-40e2-b08a-86bb2089ba64", username: "ia_user", email: "ia_user@example.com", role: :reader, hashed_password: Bcrypt.hash_pwd_salt(password), confirmed_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{slug: "4a501cb1-6e1c-45c1-8397-9bbd4a312044", username: "ca_user", email: "ca_user@example.com", role: :reader, hashed_password: Bcrypt.hash_pwd_salt(password), confirmed_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{slug: "549a7ba0-ea59-4333-bd01-eb4b3e4420f8", username: "il_user", email: "il_user@example.com", role: :reader, hashed_password: Bcrypt.hash_pwd_salt(password), confirmed_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()},
      %{slug: "b2f44567-e031-44f1-aae6-972d7aabbb45", username: "tx_user", email: "tx_user@example.com", role: :reader, hashed_password: Bcrypt.hash_pwd_salt(password), confirmed_at: NaiveDateTime.local_now(), inserted_at: NaiveDateTime.local_now()}
])

Repo.insert_all(UserScore, [
      %{id: "a9f44567-e031-44f1-aae6-972d7aabbb45", username: "admin",      score: 103, joined: ~N[2020-07-24 21:00:07]},
      %{id: "b5f44567-e031-44f1-aae6-972d7aabbb45", username: "jim_the_og", score: 84,  joined: ~N[2021-02-22 21:00:07]},
      %{id: "df18d5eb-e99e-4481-9e16-4d2f434a3711", username: "aaron",      score: 92,  joined: ~N[2021-08-05 20:00:07]},
      %{id: "67bbf29b-7ee9-48a4-b2fb-9a113e26ac91", username: "mn_voter",   score: 99,  joined: ~N[2022-09-08 23:00:07]},
      %{id: "459180af-49aa-48df-92e2-547be9283ac4", username: "wi_voter",   score: 94,  joined: ~N[2023-04-11 19:00:07]},
      %{id: "cf1ffc43-58a2-40e2-b08a-86bb2089ba64", username: "ia_voter",   score: 77,  joined: ~N[2018-12-12 13:00:07]},
      %{id: "4a501cb1-6e1c-45c1-8397-9bbd4a312044", username: "ca_voter",   score: 88,  joined: ~N[2022-11-02 23:00:07]},
      %{id: "549a7ba0-ea59-4333-bd01-eb4b3e4420f8", username: "il_voter",   score: 77,  joined: ~N[2019-06-06 14:00:07]},
      %{id: "b2f44567-e031-44f1-aae6-972d7aabbb45", username: "tx_voter",   score: 68,  joined: ~N[2023-03-05 23:00:07]}
])

# Repo.insert_all(UserScoreJson, [
#       %{user_scores: %{ "1": 79, "2": 84, "3": 108, "4": 44, "5": 65, "6": 99, "7": 100, "8": 55, "9": 101 }, inserted_at: NaiveDateTime.local_now()},
#       %{user_scores: %{ "1": 99, "2": 103, "3": 91, "4": 86, "5": 91, "6": 103, "7": 44, "8": 88, "9": 107 }, inserted_at: NaiveDateTime.local_now()},
#       %{user_scores: %{ "1": 111, "2": 94, "3": 18, "4": 39, "5": 104, "6": 82, "7": 71, "8": 48, "9": 104 }, inserted_at: NaiveDateTime.local_now()}
# ])

# Maybe username
Repo.insert_all(UserScoreJson, [
      %{user_scores: %{ admin: 79, aaron: 84, jimbo: 108, mn_user: 44, wi_user: 65, ia_user: 99, ca_user: 100, il_user: 55, tx_user: 101 }, inserted_at: NaiveDateTime.local_now()},
      %{user_scores: %{ admin: 99, aaron: 103, jimbo: 91, mn_user: 86, wi_user: 91, ia_user: 103, ca_user: 44, il_user: 88, tx_user: 107 }, inserted_at: NaiveDateTime.local_now()},
      %{user_scores: %{ admin: 111, aaron: 94, jimbo: 18, mn_user: 39, wi_user: 104, ia_user: 82, ca_user: 71, il_user: 48, tx_user: 104 }, inserted_at: NaiveDateTime.local_now()}
])

# # Ecto.UUID.bingenerate()
