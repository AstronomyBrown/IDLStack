/**
 * Vel3VectorType.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.2beta Mar 31, 2004 (12:47:03 EST) WSDL2Java emitter.
 */

package nvo_coords;

public class Vel3VectorType  extends nvo_coords.VelCoordType  implements java.io.Serializable {
    private nvo_coords.Coord3ValueType coordValue;
    private nvo_coords.Coord3SizeType coordError;
    private nvo_coords.Coord3SizeType coordResolution;
    private nvo_coords.Coord3SizeType coordSize;
    private nvo_coords.Coord3SizeType coordPixsize;
    private nvo_coords.AngleUnitType pos_ang_unit;  // attribute

    public Vel3VectorType() {
    }


    /**
     * Gets the coordValue value for this Vel3VectorType.
     * 
     * @return coordValue
     */
    public nvo_coords.Coord3ValueType getCoordValue() {
        return coordValue;
    }


    /**
     * Sets the coordValue value for this Vel3VectorType.
     * 
     * @param coordValue
     */
    public void setCoordValue(nvo_coords.Coord3ValueType coordValue) {
        this.coordValue = coordValue;
    }


    /**
     * Gets the coordError value for this Vel3VectorType.
     * 
     * @return coordError
     */
    public nvo_coords.Coord3SizeType getCoordError() {
        return coordError;
    }


    /**
     * Sets the coordError value for this Vel3VectorType.
     * 
     * @param coordError
     */
    public void setCoordError(nvo_coords.Coord3SizeType coordError) {
        this.coordError = coordError;
    }


    /**
     * Gets the coordResolution value for this Vel3VectorType.
     * 
     * @return coordResolution
     */
    public nvo_coords.Coord3SizeType getCoordResolution() {
        return coordResolution;
    }


    /**
     * Sets the coordResolution value for this Vel3VectorType.
     * 
     * @param coordResolution
     */
    public void setCoordResolution(nvo_coords.Coord3SizeType coordResolution) {
        this.coordResolution = coordResolution;
    }


    /**
     * Gets the coordSize value for this Vel3VectorType.
     * 
     * @return coordSize
     */
    public nvo_coords.Coord3SizeType getCoordSize() {
        return coordSize;
    }


    /**
     * Sets the coordSize value for this Vel3VectorType.
     * 
     * @param coordSize
     */
    public void setCoordSize(nvo_coords.Coord3SizeType coordSize) {
        this.coordSize = coordSize;
    }


    /**
     * Gets the coordPixsize value for this Vel3VectorType.
     * 
     * @return coordPixsize
     */
    public nvo_coords.Coord3SizeType getCoordPixsize() {
        return coordPixsize;
    }


    /**
     * Sets the coordPixsize value for this Vel3VectorType.
     * 
     * @param coordPixsize
     */
    public void setCoordPixsize(nvo_coords.Coord3SizeType coordPixsize) {
        this.coordPixsize = coordPixsize;
    }


    /**
     * Gets the pos_ang_unit value for this Vel3VectorType.
     * 
     * @return pos_ang_unit
     */
    public nvo_coords.AngleUnitType getPos_ang_unit() {
        return pos_ang_unit;
    }


    /**
     * Sets the pos_ang_unit value for this Vel3VectorType.
     * 
     * @param pos_ang_unit
     */
    public void setPos_ang_unit(nvo_coords.AngleUnitType pos_ang_unit) {
        this.pos_ang_unit = pos_ang_unit;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof Vel3VectorType)) return false;
        Vel3VectorType other = (Vel3VectorType) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = super.equals(obj) && 
            ((this.coordValue==null && other.getCoordValue()==null) || 
             (this.coordValue!=null &&
              this.coordValue.equals(other.getCoordValue()))) &&
            ((this.coordError==null && other.getCoordError()==null) || 
             (this.coordError!=null &&
              this.coordError.equals(other.getCoordError()))) &&
            ((this.coordResolution==null && other.getCoordResolution()==null) || 
             (this.coordResolution!=null &&
              this.coordResolution.equals(other.getCoordResolution()))) &&
            ((this.coordSize==null && other.getCoordSize()==null) || 
             (this.coordSize!=null &&
              this.coordSize.equals(other.getCoordSize()))) &&
            ((this.coordPixsize==null && other.getCoordPixsize()==null) || 
             (this.coordPixsize!=null &&
              this.coordPixsize.equals(other.getCoordPixsize()))) &&
            ((this.pos_ang_unit==null && other.getPos_ang_unit()==null) || 
             (this.pos_ang_unit!=null &&
              this.pos_ang_unit.equals(other.getPos_ang_unit())));
        __equalsCalc = null;
        return _equals;
    }

    private boolean __hashCodeCalc = false;
    public synchronized int hashCode() {
        if (__hashCodeCalc) {
            return 0;
        }
        __hashCodeCalc = true;
        int _hashCode = super.hashCode();
        if (getCoordValue() != null) {
            _hashCode += getCoordValue().hashCode();
        }
        if (getCoordError() != null) {
            _hashCode += getCoordError().hashCode();
        }
        if (getCoordResolution() != null) {
            _hashCode += getCoordResolution().hashCode();
        }
        if (getCoordSize() != null) {
            _hashCode += getCoordSize().hashCode();
        }
        if (getCoordPixsize() != null) {
            _hashCode += getCoordPixsize().hashCode();
        }
        if (getPos_ang_unit() != null) {
            _hashCode += getPos_ang_unit().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(Vel3VectorType.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("urn:nvo-coords", "vel3VectorType"));
        org.apache.axis.description.AttributeDesc attrField = new org.apache.axis.description.AttributeDesc();
        attrField.setFieldName("pos_ang_unit");
        attrField.setXmlName(new javax.xml.namespace.QName("", "pos_ang_unit"));
        attrField.setXmlType(new javax.xml.namespace.QName("urn:nvo-coords", "angleUnitType"));
        typeDesc.addFieldDesc(attrField);
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("coordValue");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:nvo-coords", "CoordValue"));
        elemField.setXmlType(new javax.xml.namespace.QName("urn:nvo-coords", "coord3ValueType"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("coordError");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:nvo-coords", "CoordError"));
        elemField.setXmlType(new javax.xml.namespace.QName("urn:nvo-coords", "coord3SizeType"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("coordResolution");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:nvo-coords", "CoordResolution"));
        elemField.setXmlType(new javax.xml.namespace.QName("urn:nvo-coords", "coord3SizeType"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("coordSize");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:nvo-coords", "CoordSize"));
        elemField.setXmlType(new javax.xml.namespace.QName("urn:nvo-coords", "coord3SizeType"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("coordPixsize");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:nvo-coords", "CoordPixsize"));
        elemField.setXmlType(new javax.xml.namespace.QName("urn:nvo-coords", "coord3SizeType"));
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
