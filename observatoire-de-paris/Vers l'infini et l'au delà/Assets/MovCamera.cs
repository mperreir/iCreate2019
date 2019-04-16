using UnityEngine;

/*
 * MovCamera permet de gérer la caméra en modifiant les coordonnées de rotation de celle-ci
*/
public class MovCamera : MonoBehaviour
{
    //Camera de la scène prinipale
    [SerializeField]
    private Camera cam;
    //Scène d'affichage d'informations d'une exoplanete en question
    private ShowInfo SI;

    public OSC osc;
    //Float permettant de modifier les mouvements effectués par le téléphone afin de les rendre à l'échelle de la projection
    private float coeffGyrX = 0.75f;
    private float coeffGyrZ = 0.30f;

    private Rigidbody rb;
    //Float représentant un bruit minimal, permettant de ne pas prendre en compte certains mouvements minimes du téléphone
    private float bruitMin = 0.05f;

    //Vecteur permettant de stocker les informations données par le gyroscope du téléphone
    private Vector3 vectGyroscope;
    //Vecteur permettant de stocker les informations données par le rotationvector du téléphone
    private Vector3 vectAccelerator;

    // Start is called before the first frame update
    private void Start()
    {
        //Permet de recevoir les informations sur le capteur "gyroscope" provenant du téléphone,
        //et d'y appliquer la fonction OnReceiveGyr à chaque réception d'informations
        osc.SetAddressHandler("/gyroscope", OnReceiveGyr);
        //Permet de recevoir les informations sur le capteur "rotationvector" provenant du téléphone,
        //et d'y appliquer la fonction OnReceiveGyr à chaque réception d'informations
        //osc.SetAddressHandler("/rotationvector", OnReceiveRotVec);

        //Récupération du composant "lunette" afin de pouvoir modifier ses caractéristiques
        rb = GetComponent<Rigidbody>();
        //Récupération du componsant "caméra principale" afin de pouvoir modifier ses caractéristiques par la suite
        cam = GetComponentInChildren<Camera>();
    }

    // Update is called once per frame
    private void Update()
    {
        //Si la touche "R" du clavier est préssée
        if (Input.GetKeyDown(KeyCode.R))
        {
            //Création d'un quaternion (rotation pour les angles)
            Quaternion q = transform.rotation;
            //Association d'une rotation à ce quaternion
            q.eulerAngles = new Vector3(0, 180, 0);
            //Modification de l'angle de la caméra, permettant de la replacer au centre de la projection au cas où
            transform.rotation = q;
        }
    }

    //Fonction permettant de gérer l'orientation de la caméra principale
    private void OnReceiveGyr(OscMessage oscM)
    {
        //Récupértion des valeurs de la caméra sur les 3 axes de rotation, X, Y et Z
        float x = oscM.GetFloat(0);
        float y = oscM.GetFloat(1);
        float z = oscM.GetFloat(2);

        //Si le nom de la caméra étudiée est "Caméra" (étant le nom de la caméra principale)
        if (string.Equals(cam.name,"Camera"))
        {
            //Modification des valeurs du vecteur de rotation avec les coordonnées de rotation du téléphone et des coefficients particuliers appliqués
            //permettant de rendre les mouvements effectués dans la réalité à l'échelle sur la projection
            vectGyroscope = new Vector3(-x * coeffGyrX, -z * coeffGyrZ, 0);
        }
        //Sinon
        else
        {
            //Modification des valeurs du vecteur de rotation avec les coordonnées de rotation du téléphone
            vectGyroscope = new Vector3(-x, -z, 0);
        }

        //Si le mouvement effectué par le téléphone est supérieur à un bruit minimal (afin d'éviter de compter les petits mouvements)
        if (Mathf.Abs(x) > bruitMin || Mathf.Abs(y) > bruitMin || Mathf.Abs(z) > bruitMin)
        {
            //Rotation de l'angle de la caméra appliqué à la caméra principale selon le vecteur de gyroscope
            transform.Rotate(vectGyroscope);

            //Création d'un quaternion (rotation pour les angles)
            Quaternion q = transform.rotation;
            //Association d'une rotation à ce quaternion en fonction des nouvelles valeurs
            q.eulerAngles = new Vector3(q.eulerAngles.x, q.eulerAngles.y, 0);
            //Modification de l'angle de la caméra
            transform.rotation = q;
        }
    }

    //Fonction permettant de gérer le field of view de la caméra principale
    /*
    //ZOOM DE LA CAMERA
    private void OnReceiveRotVec(OscMessage oscM)
    {
        //Debug.Log("----- RECEPTION DU ROTATIONVECTOR -----");

        float x = oscM.GetFloat(0);
        float y = oscM.GetFloat(1);
        float z = oscM.GetFloat(2);

        if (y < -0.20 && cam.fieldOfView < 70)
        {
            cam.fieldOfView += 0.1f * cam.fieldOfView / 3;
        }
        else if (y > 0.20 && cam.fieldOfView > 0)
        {
            cam.fieldOfView -= 0.1f * cam.fieldOfView / 3;
        }

    }
    */
}
