defmodule StreamHandler.Core.Utils do

    # Ensure these are alphabetical. Legiscan API state IDs based on that. NE = 27 & MN = 23
    def states do
        [:AL,:AK,:AZ,:AR,:CA,:CO,:CT,:DE,:FL,:GA,:HI,:ID,:IL,:IN,:IA,:KS,:KY,:LA,:ME,:MD,:MA,
        :MI,:MN,:MS,:MO,:MT,:NE,:NV,:NH,:NJ,:NM,:NY,:NC,:ND,:OH,:OK,:OR,:PA,:RI,:SC,:SD,:TN,
        :TX,:UT,:VT,:VA,:WA,:WV,:WI,:WY,:AS,:GU,:MP,:PR,:VI,:DC]
    end

    def state_names do
        [:Alabama,:Alaska,:Arizona,:Arkansas,:California,:Colorado,:Connecticut,:Delaware,:Florida,:Georgia,
        :Hawaii,:Idaho,:Illinois,:Indiana,:Iowa,:Kansas,:Kentucky,:Louisiana,:Maine,:Maryland,:Massachusetts,
        :Michigan,:Minnesota,:Mississippi,:Missouri,:Montana,:Nebraska,:Nevada,:New_Hampshire,:New_Jersey,:New_Mexico,
        :New_York,:North_Carolina,:North_Dakota,:Ohio,:Oklahoma,:Oregon,:Pennsylvania,:Rhode_Island,:South_Carolina,
        :South_Dakota,:Tennessee,:Texas,:Utah,:Vermont,:Virginia,:Washington,:West_Virginia,:Wisconsin,:Wyoming]
    end

    def territories do
        [:American_Samoa, :Guam, :Northern_Mariana_Islands, :Peurto_Rico, :Virgin_Islands, :District_of_Columbia]
    end

    def suffixes do
        [:Sr, :Jr, :III, :II]
    end

    def prefixes do
        [:Mr, :Mrs, :Ms, :Miss, :Dr]
    end

    def no_image do
        "https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png"
    end

    def attachment_types do
        [:image, :pdf]
    end

    # Holds = Things you can only have one of
    # Event = Can have many

    def hold_types do
        [:follow, :star, :bookmark, :alert, :vote, :like, :share, :upvote, :downvote, :favorite]
    end

    def hold_cats do
        [:user, :beer, :bank, :headline]
    end

    def event_types do
        [:share, :like]
    end

    def roles do
        [:admin, :reader, :subadmin]
    end

    def message_type do
        [:p2p, :dm, :advert, :cast]
    end

    def resources do
        [:ballot, :election, :user, :candidate, :race, :forum, :post, :thread]
    end

    def forum_categories do
        [:Site, :General, :Politics, :State]
    end

    @spec display_missing_fields(list()) :: binary()
    def display_missing_fields(missing) do
        List.foldl(missing, "", fn x, acc ->
          if (x) do
            (to_string(x) |> String.capitalize()) <> " " <> acc
          else
            acc
          end
        end) |> String.trim()
    end
end
