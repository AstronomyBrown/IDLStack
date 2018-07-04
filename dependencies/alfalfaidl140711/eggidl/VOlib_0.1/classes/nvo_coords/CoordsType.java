/**
 * CoordsType.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.2beta Mar 31, 2004 (12:47:03 EST) WSDL2Java emitter.
 */

package nvo_coords;

public class CoordsType  implements java.io.Serializable {
    private nvo_coords.VelScalarType velScalar;
    private nvo_coords.Vel3VectorType vel3Vector;
    private nvo_coords.CoordSpectralType spectrum;
    private org.apache.axis.types.URI coordFile;
    private nvo_coords.CoordTimeType time;
    private nvo_coords.Vel2VectorType vel2Vector;
    private nvo_coords.Pos2VectorType pos2Vector;
    private nvo_coords.PosScalarType posScalar;
    private nvo_coords.Pos3VectorType pos3Vector;
    private nvo_coords.VelScalarType redshift;
    private org.apache.axis.types.Id ID;  // attribute
    private org.apache.axis.types.IDRef coord_system_id;  // attribute

    public CoordsType() {
    }


    /**
     * Gets the velScalar value for this CoordsType.
     * 
     * @return velScalar
     */
    public nvo_coords.VelScalarType getVelScalar() {
        return velScalar;
    }


    /**
     * Sets the velScalar value for this CoordsType.
     * 
     * @param velScalar
     */
    public void setVelScalar(nvo_coords.VelScalarType velScalar) {
        this.velScalar = velScalar;
    }


    /**
     * Gets the vel3Vector value for this CoordsType.
     * 
     * @return vel3Vector
     */
    public nvo_coords.Vel3VectorType getVel3Vector() {
        return vel3Vector;
    }


    /**
     * Sets the vel3Vector value for this CoordsType.
     * 
     * @param vel3Vector
     */
    public void setVel3Vector(nvo_coords.Vel3VectorType vel3Vector) {
        this.vel3Vector = vel3Vector;
    }


    /**
     * Gets the spectrum value for this CoordsType.
     * 
     * @return spectrum
     */
    public nvo_coords.CoordSpectralType getSpectrum() {
        return spectrum;
    }


    /**
     * Sets the spectrum value for this CoordsType.
     * 
     * @param spectrum
     */
    public void setSpectrum(nvo_coords.CoordSpectralType spectrum) {
        this.spectrum = spectrum;
    }


    /**
     * Gets the coordFile value for this CoordsType.
     * 
     * @return coordFile
     */
    public org.apache.axis.types.URI getCoordFile() {
        return coordFile;
    }


    /**
     * Sets the coordFile value for this CoordsType.
     * 
     * @param coordFile
     */
    public void setCoordFile(org.apache.axis.types.URI coordFile) {
        this.coordFile = coordFile;
    }


    /**
     * Gets the time value for this CoordsType.
     * 
     * @return time
     */
    public nvo_coords.CoordTimeType getTime() {
        return time;
    }


    /**
     * Sets the time value for this CoordsType.
     * 
     * @param time
     */
    public void setTime(nvo_coords.CoordTimeType time) {
        this.time = time;
    }


    /**
     * Gets the vel2Vector value for this CoordsType.
     * 
     * @return vel2Vector
     */
    public nvo_coords.Vel2VectorType getVel2Vector() {
        return vel2Vector;
    }


    /**
     * Sets the vel2Vector value for this CoordsType.
     * 
     * @param vel2Vector
     */
    public void setVel2Vector(nvo_coords.Vel2VectorType vel2Vector) {
        this.vel2Vector = vel2Vector;
    }


    /**
     * Gets the pos2Vector value for this CoordsType.
     * 
     * @return pos2Vector
     */
    public nvo_coords.Pos2VectorType getPos2Vector() {
        return pos2Vector;
    }


    /**
     * Sets the pos2Vector value for this CoordsType.
     * 
     * @param pos2Vector
     */
    public void setPos2Vector(nvo_coords.Pos2VectorType pos2Vector) {
        this.pos2Vector = pos2Vector;
    }


    /**
     * Gets the posScalar value for this CoordsType.
     * 
     * @return posScalar
     */
    public nvo_coords.PosScalarType getPosScalar() {
        return posScalar;
    }


    /**
     * Sets the posScalar value for this CoordsType.
     * 
     * @param posScalar
     */
    public void setPosScalar(nvo_coords.PosScalarType posScalar) {
        this.posScalar = posScalar;
    }


    /**
     * Gets the pos3Vector value for this CoordsType.
     * 
     * @return pos3Vector
     */
    public nvo_coords.Pos3VectorType getPos3Vector() {
        return pos3Vector;
    }


    /**
     * Sets the pos3Vector value for this CoordsType.
     * 
     * @param pos3Vector
     */
    public void setPos3Vector(nvo_coords.Pos3VectorType pos3Vector) {
        this.pos3Vector = pos3Vector;
    }


    /**
     * Gets the redshift value for this CoordsType.
     * 
     * @return redshift
     */
    public nvo_coords.VelScalarType getRedshift() {
        return redshift;
    }


    /**
     * Sets the redshift value for this CoordsType.
     * 
     * @param redshift
     */
    public void setRedshift(nvo_coords.VelScalarType redshift) {
        this.redshift = redshift;
    }


    /**
     * Gets the ID value for this CoordsType.
     * 
     * @return ID
     */
    public org.apache.axis.types.Id getID() {
        return ID;
    }


    /**
     * Sets the ID value for this CoordsType.
     * 
     * @param ID
     */
    public void setID(org.apache.axis.types.Id ID) {
        this.ID = ID;
    }


    /**
     * Gets the coord_system_id value for this CoordsType.
     * 
     * @return coord_system_id
     */
    public org.apache.axis.types.IDRef getCoord_system_id() {
        return coord_system_id;
    }


    /**
     * Sets the coord_system_id value for this CoordsType.
     * 
     * @param coord_system_id
     */
    public void setCoord_system_id(org.apache.axis.types.IDRef coord_system_id) {
        this.coord_system_id = coord_system_id;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof CoordsType)) return false;
        CoordsType other = (CoordsType) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.velScalar==null && other.getVelScalar()==null) || 
             (this.velScalar!=null &&
              this.velScalar.equals(other.getVelScalar()))) &&
            ((this.vel3Vector==null && other.getVel3Vector()==null) || 
             (this.vel3Vector!=null &&
              this.vel3Vector.equals(other.getVel3Vector()))) &&
            ((this.spectrum==null && other.getSpectrum()==null) || 
             (this.spectrum!=null &&
              this.spectrum.equals(other.getSpectrum()))) &&
            ((this.coordFile==null && other.getCoordFile()==null) || 
             (this.coordFile!=null &&
              this.coordFile.equals(other.getCoordFile()))) &&
            ((this.time==null && other.getTime()==null) || 
             (this.time!=null &&
              this.time.equals(other.getTime()))) &&
            ((this.vel2Vector==null && other.getVel2Vector()==null) || 
             (this.vel2Vector!=null &&
              this.vel2Vector.equals(other.getVel2Vector()))) &&
            ((this.pos2Vector==null && other.getPos2Vector()==null) || 
             (this.pos2Vector!=null &&
              this.pos2Vector.equals(other.getPos2Vector()))) &&
            ((this.posScalar==null && other.getPosScalar()==null) || 
             (this.posScalar!=null &&
              this.posScalar.equals(other.getPosScalar()))) &&
            ((this.pos3Vector==null && other.getPos3Vector()==null) || 
             (this.pos3Vector!=null &&
              this.pos3Vector.equals(other.getPos3Vector()))) &&
            ((this.redshift==null && other.getRedshift()==null) || 
             (this.redshift!=null &&
              this.redshift.equals(other.getRedshift()))) &&
            ((this.ID==null && other.getID()==null) || 
             (this.ID!=null &&
              this.ID.equals(other.getID()))) &&
            ((this.coord_system_id==null && other.getCoord_system_id()==null) || 
             (this.coord_system_id!=null &&
              this.coord_system_id.equals(other.getCoord_system_id())));
        __equalsCalc = null;
        return _equals;
    }

    private boolean __hashCodeCalc = false;
    public synchronized int hashCode() {
        if (__hashCodeCalc) {
            return 0;
        }
        __hashCodeCalc = true;
        int _hashCode = 1;
        if (getVelScalar() != null) {
            _hashCode += getVelScalar().hashCode();
        }
        if (getVel3Vector() != null) {
            _hashCode += getVel3Vector().hashCode();
        }
        if (getSpectrum() != null) {
            _hashCode += getSpectrum().hashCode();
        }
        if (getCoordFile() != null) {
            _hashCode += getCoordFile().hashCode();
        }
        if (getTime() != null) {
            _hashCode += getTime().hashCode();
        }
        if (getVel2Vector() != null) {
            _hashCode += getVel2Vector().hashCode();
        }
        if (getPos2Vector() != null) {
            _hashCode += getPos2Vector().hashCode();
        }
        if (getPosScalar() != null) {
            _hashCode += getPosScalar().hashCode();
        }
        if (getPos3Vector() != null) {
            _hashCode += getPos3Vector().hashCode();
        }
        if (getRedshift() != null) {
            _hashCode += getRedshift().hashCode();
        }
        if (getID() != null) {
            _hashCode += getID().hashCode();
        }
        if (getCoord_system_id() != null) {
            _hashCode += getCoord_system_id().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(CoordsType.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("urn:nvo-coords", "coordsType"));
        org.apache.axis.description.AttributeDesc attrField = new org.apache.axis.description.AttributeDesc();
        attrField.setFieldName("ID");
        attrField.setXmlName(new javax.xml.namespace.QName("", "ID"));
        attrField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "ID"));
        typeDesc.addFieldDesc(attrField);
        attrField = new org.apache.axis.description.AttributeDesc();
        attrField.setFieldName("coord_system_id");
        attrField.setXmlName(new javax.xml.namespace.QName("", "coord_system_id"));
        attrField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "IDREF"));
        typeDesc.addFieldDesc(attrField);
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("velScalar");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:nvo-coords", "VelScalar"));
        elemField.setXmlType(new javax.xml.namespace.QName("urn:nvo-coords", "velScalarType"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("vel3Vector");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:nvo-coords", "Vel3Vector"));
        elemField.setXmlType(new javax.xml.namespace.QName("urn:nvo-coords", "vel3VectorType"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("spectrum");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:nvo-coords", "Spectrum"));
        elemField.setXmlType(new javax.xml.namespace.QName("urn:nvo-coords", "coordSpectralType"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("coordFile");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:nvo-coords", "CoordFile"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "anyURI"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("time");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:nvo-coords", "Time"));
        elemField.setXmlType(new javax.xml.namespace.QName("urn:nvo-coords", "coordTimeType"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("vel2Vector");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:nvo-coords", "Vel2Vector"));
        elemField.setXmlType(new javax.xml.namespace.QName("urn:nvo-coords", "vel2VectorType"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("pos2Vector");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:nvo-coords", "Pos2Vector"));
        elemField.setXmlType(new javax.xml.namespace.QName("urn:nvo-coords", "pos2VectorType"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("posScalar");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:nvo-coords", "PosScalar"));
        elemField.setXmlType(new javax.xml.namespace.QName("urn:nvo-coords", "posScalarType"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("pos3Vector");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:nvo-coords", "Pos3Vector"));
        elemField.setXmlType(new javax.xml.namespace.QName("urn:nvo-coords", "pos3VectorType"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("redshift");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:nvo-coords", "Redshift"));
        elemField.setXmlType(new javax.xml.namespace.QName("urn:nvo-coords", "velScalarType"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
    }

    /**
     * Return type metadata object
     */
    public static org.apache.axis.description.TypeDesc getTypeDesc() {
        return typeDesc;
    }

    /**
     * Get Custom Serializer
     */
    public static org.apache.axis.encoding.Serializer getSerializer(
           java.lang.String mechType, 
           java.lang.Class _javaType,  
           javax.xml.namespace.QName _xmlType) {
        return 
          new  org.apache.axis.encoding.ser.BeanSerializer(
            _javaType, _xmlType, typeDesc);
    }

    /**
     * Get Custom Deserializer
     */
    public static org.apache.axis.encoding.Deserializer getDeserializer(
           java.lang.String mechType, 
           java.lang.Class _javaType,  
           javax.xml.namespace.QName _xmlType) {
        return 
          new  org.apache.axis.encoding.ser.BeanDeserializer(
            _javaType, _xmlType, typeDesc);
    }

}
