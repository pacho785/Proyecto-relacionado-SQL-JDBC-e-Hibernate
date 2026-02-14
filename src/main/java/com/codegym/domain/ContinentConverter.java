package com.codegym.domain;

import javax.persistence.AttributeConverter;
import javax.persistence.Converter;

@Converter(autoApply = true)
public class ContinentConverter implements AttributeConverter<Continent, String> {

    @Override
    public String convertToDatabaseColumn(Continent attribute) {
        if (attribute == null) {
            return null;
        }
        switch (attribute) {
            case ASIA:
                return "Asia";
            case EUROPE:
                return "Europe";
            case NORTH_AMERICA:
                return "North America";
            case AFRICA:
                return "Africa";
            case OCEANIA:
                return "Oceania";
            case ANTARCTICA:
                return "Antarctica";
            case SOUTH_AMERICA:
                return "South America";
            default:
                return null;
        }
    }

    @Override
    public Continent convertToEntityAttribute(String dbData) {
        if (dbData == null || dbData.isEmpty()) {
            return null;
        }
        switch (dbData.trim()) {
            case "Asia":
                return Continent.ASIA;
            case "Europe":
                return Continent.EUROPE;
            case "North America":
                return Continent.NORTH_AMERICA;
            case "Africa":
                return Continent.AFRICA;
            case "Oceania":
                return Continent.OCEANIA;
            case "Antarctica":
                return Continent.ANTARCTICA;
            case "South America":
                return Continent.SOUTH_AMERICA;
            default:
                return null;
        }
    }
}

