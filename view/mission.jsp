<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="/immobilisation/assets/bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="/immobilisation/assets/bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="/immobilisation/assets/bootstrap-icons/font/bootstrap-icons.css">
    <link rel="stylesheet" href="/immobilisation/assets/css/style.css">
    <link rel="stylesheet" href="/immobilisation/assets/css/header.css">
    <link rel="stylesheet" href="/immobilisation/assets/css/dashboard.css">
    <script async src="https://maps.googleapis.com/maps/api/js?key=AIzaSyCLOP60qAU_9opw74IE-vjVeW589hcJpes&callback=console.debug&libraries=maps,marker&v=beta">
    </script>
    <title>Dashboard</title>
    <style>
        .sticky-offset {
            top: 20px;
        }

        .red {
            accent-color: red;
        }
        .green {
            accent-color: green;
        }
        
        .yellow {
            accent-color: yellow;
        }

        gmp-map {
            height: 100%;
            border-radius: 15px;
        }

        /* Optional: Makes the sample page fill the window. */
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row" style="background-color: #f5f2ec;">
            
            
            <jsp:include page="./header.html" />


            <div class="col my-4 mx-4 min-vh-100">
                <div class="w-50">
                    <gmp-map center="-18.918378829956055,47.521141052246094" zoom="14" map-id="DEMO_MAP_ID">
                        <gmp-advanced-marker position="-18.918378829956055,47.521141052246094" title="My location"></gmp-advanced-marker>
                    </gmp-map>
                </div>
                <div>

                </div>
            </div>
        </div>
    </div>
</body>
</html>