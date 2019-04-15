using UnityEngine;
using System.Collections;

public class Calibrate : MonoBehaviour
{
    [SerializeField]
    public OSC osc;

    // Valeurs directs du gyroscope sur les axes X et Z
    private float xGyr;
    private float zGyr;

    // Distances angulaires totaux parcourues sur les axes X et Z
    private float ttXGyr = 70;
    private float ttZGyr = 70;

    // Script liée au mouvement de la loupe et des camérasO
    // On viendra changer les coefficients pour calibrer le mouvement selon les distances angulaires totaux (ttXGyr, ttZGyr)
    private MovCamera scriptMov;

    private bool onCalibrate = false;

    private void Start()
    {
        osc.SetAddressHandler("/gyroscope", OnReceiveGyr);
        scriptMov = GetComponent<MovCamera>();
    }

    private void Update()
    {
        // Démarrage du calibrage en appuyant sur la touche Espace, il faut diriger le téléphone en bas à droite de notre surface de jeu
        if (Input.GetKeyDown(KeyCode.Space) && !onCalibrate)
        {
            Debug.Log("In Calibrate");
            onCalibrate = true;
            ttXGyr = 0;
            ttZGyr = 0;
        }
        // Fin du calibrage en appuyant sur la touche C, les distances angulaires sont fixées
        if (Input.GetKeyDown(KeyCode.C) && onCalibrate)
        {
            onCalibrate = false;
            Debug.Log(ttXGyr);
            Debug.Log(ttZGyr);
        }
        // Réinitialisation, on applique les coefficents selon les distances et des constantes que sont les angles entre notre point de rotation et notre background du jeu
        // De plus, il faut dirigier le téléphone au centre de la surface de jeu, on réinitialise la position de la loupe pour que le téléphone et la loupe soit synchronisés
        if (Input.GetKeyDown(KeyCode.R) && !onCalibrate)
        {
            Debug.Log("RESET");
            scriptMov.coeffGyrX = (float)7.91 / ttXGyr;
            scriptMov.coeffGyrZ = (float)9.28 / ttZGyr;
            Quaternion q = transform.rotation;
            q.eulerAngles = new Vector3(0, 180, 0);
            transform.rotation = q;
        }
    }

    private void OnReceiveGyr(OscMessage oscM)
    {
        xGyr = oscM.GetFloat(0);
        zGyr = oscM.GetFloat(2);

        // Lorsque l'on a commencé le calibrage, on calcul les distances angulaires parcourues jusqu'à la fin du calibrage
        if (onCalibrate)
        {
            ttXGyr += xGyr;
            ttZGyr += zGyr;
        }
    }

    /* Valeur angle jusqu'à la droite ou la gauche du background = 7.91 
       Valeur angle jusqu'en haut ou en bas du background = 9.28 */

}
