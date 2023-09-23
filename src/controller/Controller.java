/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package controller;

/**
 *
 * @author ADMIN
 */

import java.util.List;

public interface Controller {

    <T> void writeToFile(List<T> list, String fileName);

    <T> List<T> readDataFromFile(String fileName);

    //<T> void sortByName(List<T> list);
    
    //<T> void sortByBuses(List<T> list);
    
    //<T> void sortByTotalDistance(List<T> list);
}
