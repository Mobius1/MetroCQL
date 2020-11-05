Config = {}

Config.DataContainer        = "Levels/MP_Subway/Conquest_Small"
Config.LogicWorldPart       = Guid('308934A9-8735-4467-B9F4-A61F700108D3')
Config.RegistryContainer    = Guid('711883E6-D355-9753-9C3B-A933FA58F329')
Config.LogicPartition       = Guid('F5DE48B8-29ED-4E73-B040-82637BE0E81C')

Config.Flags = {
    {
        Letter = "D",
        Label = "PERGOLA",
        Prefab = Guid('0EBE4C00-9840-4D65-49CB-019C23BBC66B'),
        Pos = Vec3(-63.743168, 69.712700, -66.124023),
        CaptureArea = {
            Vec3(-89.342407, 69.032303, -45.921181),
            Vec3(-89.342407, 69.032303, -90.550529),
            Vec3(-40.289146, 69.032303, -90.550529),
            Vec3(-40.289146, 69.032303, -45.921181)
        },
    },
    {
        Letter = "E",
        Label = "BRIDGE",
        Prefab = Guid('0EBE4C00-9840-4D65-49CB-019C23BBC66B'),
        Pos = Vec3(-21.947266, 63.785988, 95.391579),
        CaptureArea = {
            Vec3(-6.287228, 65.646019, 78.132500),
            Vec3(0.335540, 65.855797, 105.312859),
            Vec3(-35.617466, 66.841232, 114.661179),
            Vec3(-46.323788, 67.368546, 94.859337)
        },
    },    
}

Config.Redzones = {
    ["US"] = {
        HQ = { 
            Guid = Guid('67FFDD5E-FB56-4F56-9771-DC9915D0DDE5'),
            Pos = Vec3(56.399414, 64.030090, 269.802734),
            Spawns = {
                {
                    Guid        = Guid('1B0D2B3A-283E-43CF-96CB-E1D0D3041A4C'),
                    Transform   = LinearTransform(Vec3(-0.904072, 0.000001, 0.427381), Vec3(0.000001, 1.000000, -0.000000), Vec3(-0.427381, -0.000000, -0.904072), Vec3(51.264153, 64.000977, 257.516235))
                },
                {
                    Guid        = Guid('5A1B3B99-1C03-45DB-8929-680E4CF8AD7A'),
                    Transform   = LinearTransform(Vec3(-0.904072, 0.000001, 0.427381), Vec3(0.000001, 1.000000, -0.000000), Vec3(-0.427381, -0.000000, -0.904072), Vec3(66.488640, 64.000977, 251.665344)),
                },
                {
                    Guid        = Guid('7594587B-F443-431D-88E7-26FA96215332'),
                    Transform   = LinearTransform(Vec3(-0.737393, 0.000000, 0.675464), Vec3(0.000000, 1.000000, -0.000000), Vec3(-0.675464, -0.000000, -0.737393), Vec3(33.725922, 64.716774, 279.037476)),
                },
                {
                    Guid        = Guid('3444C0F7-D1E3-4CDD-9E99-32A09B521548'),
                    Transform   = LinearTransform(Vec3(-0.987480, 0.000000, 0.157747), Vec3(0.000000, 1.000000, -0.000000), Vec3(-0.157747, -0.000000, -0.987480), Vec3(36.093212, 64.908966, 249.531464)),
                },
                {
                    Guid        = Guid('0F58560C-B41F-489B-93A8-2D60AA056490'),
                    Transform   = LinearTransform(Vec3(-0.904071, 0.000001, 0.427381), Vec3(0.000001, 1.000000, -0.000000), Vec3(-0.427381, -0.000000, -0.904071), Vec3(43.557186, 65.159920, 230.257385)),
                },
                {
                    Guid        = Guid('2799182E-8421-4341-971D-9EBAF2455613'),
                    Transform   = LinearTransform(Vec3(-0.904072, 0.000000, 0.427381), Vec3(0.000000, 1.000000, -0.000000), Vec3(-0.427381, -0.000000, -0.904072), Vec3(64.225975, 64.721878, 220.693771)),
                }
            },
        },
        Guid = Guid('081BC71A-E784-49FA-9BDA-02FC1354FE48'),
        Points = {
            Vec3(-85.158966, 62.319305, -577.893494),
            Vec3(-70.803986, 71.310822, -141.587372),
            Vec3(95.109070, 72.570663, -141.514771),
            Vec3(110.277969, 60.327579, 188.215546),
            Vec3(11.955346, 69.080452, 281.499054),
            Vec3(-21.194397, 69.534012, 249.098602),
            Vec3(-3.326215, 70.559731, 230.682739),
            Vec3(-75.040733, 70.000702, 161.090546),
            Vec3(-92.882820, 70.454269, 179.300690),
            Vec3(-146.383606, 71.297028, 127.146957),
            Vec3(-146.439377, 71.211739, 81.475594),
            Vec3(-114.081818, 69.932816, 81.275597),
            Vec3(-114.122185, 69.668182, -18.544220),
            Vec3(-146.360275, 71.268036, -18.544216),
            Vec3(-282.880432, 62.319305, -576.701538)
        }
    },
    ["RU"] = {
        Guid = Guid('11119EDC-CD69-44A9-A5CC-DC7464A984AD'),
        Points = {
            Vec3(45.986992, 62.950466, 112.631683),
            Vec3(-11.280718, 66.498520, 152.021912),
            Vec3(-15.363543, 66.655838, 167.268723),
            Vec3(-75.125404, 69.999954, 161.046371),
            Vec3(-92.867096, 70.653481, 179.311127),
            Vec3(-146.436157, 71.535500, 127.095734),
            Vec3(-284.242340, 60.834118, -642.920715),
            Vec3(-174.580460, 60.834118, -673.810303),
            Vec3(-84.889572, 60.834118, -576.645813)
        }        
    }
}