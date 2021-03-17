table 14228880 "Sales Order Signature"
{

    fields
    {
        field(10; "Order No."; Code[20])
        {
        }
        field(20; Signature; BLOB)
        {
            SubType = Bitmap;
        }
    }

    keys
    {
        key(Key1; "Order No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

