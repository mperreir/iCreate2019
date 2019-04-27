function enregistrement(id)
{
    if(document.getElementById(id).value=="Démarrer la capture") {
        document.getElementById(id).disabled = true;
        document.getElementById('chrono').innerHTML = "3";
        console.log("3");
        setTimeout(function(){
        document.getElementById('chrono').innerHTML = "2";
            console.log("2");
            setTimeout(function(){
            document.getElementById('chrono').innerHTML = "1";
                console.log("1");
                setTimeout(function(){
                document.getElementById('chrono').innerHTML = "ça tourne !";
                    console.log("ça tourne");
                    player.record().start();
                    setTimeout(function(){
                        document.getElementById(id).value = "Etape suivante";
                        document.getElementById(id).disabled = false;
                    }, 5000);
                }, 1000);
            }, 1000);
        }, 1000);
    } else if (document.getElementById(id).value=="Etape suivante") {
        if (id=="nom") {
            window.location.href = "ville.html";
        } else if (id=="ville") {
            window.location.href = "dispute.html";
        } else if (id=="dispute") {
            window.location.href = "fin.html";
        }
    }
};

function recommencer(id)
{
    document.getElementById('chrono').innerHTML = "";
    document.getElementById(id).disabled = false;
    document.getElementById(id).value = "Démarrer la capture";
    player.record().reset();
};
