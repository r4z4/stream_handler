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

alias StreamHandler.Repo
alias StreamHandler.Streams.UserScore


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

# # Ecto.UUID.bingenerate()
