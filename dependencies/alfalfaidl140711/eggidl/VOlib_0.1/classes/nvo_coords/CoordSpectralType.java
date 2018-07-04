/**
 * CoordSpectralType.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.2beta Mar 31, 2004 (12:47:03 EST) WSDL2Java emitter.
 */

package nvo_coords;

public class CoordSpectralType  implements java.io.Serializable {
    private java.lang.String name;
    private nvo_coords.CoordSpectralValueType coordValue;
    private nvo_coords.CoordSpectralValueType coordError;
    private nvo_coords.CoordSpectralValueType coordResolution;
    private nvo_coords.CoordSpectralValueType coordSize;
    private nvo_coords.CoordSpectralValueType coordPixsize;

    public CoordSpectralType() {
    }


    /**
     * Gets the name value for this CoordSpectralType.
     * 
     * @return name
     */
    public java.lang.String getName() {
        return name;
    }


    /**
     * Sets the name value for this CoordSpectralType.
     * 
     * @param name
     */
    public void setName(java.lang.String name) {
        this.name = name;
    }


    /**
     * Gets the coordValue value for this CoordSpectralType.
     * 
     * @return coordValue
     */
    public nvo_coords.CoordSpectralValueType getCoordValue() {
        return coordValue;
    }


    /**
     * Sets the coordValue value for this CoordSpectralType.
     * 
     * @param coordValue
     */
    public void setCoordValue(nvo_coords.CoordSpectralValueType coordValue) {
        this.coordValue = coordValue;
    }


    /**
     * Gets the coordError value for this CoordSpectralType.
     * 
     * @return coordError
     */
    public nvo_coords.CoordSpectralValueType getCoordError() {
        return coordError;
    }


    /**
     * Sets the coordError value for this CoordSpectralType.
     * 
     * @param coordError
     */
    public void setCoordError(nvo_coords.CoordSpectralValueType coordError) {
        this.coordError = coordError;
    }


    /**
     * Gets the coordResolution value for this CoordSpectralType.
     * 
     * @return coordResolution
     */
    public nvo_coords.CoordSpectralValueType getCoordResolution() {
        return coordResolution;
    }


    /**
     * Sets the coordResolution value for this CoordSpectralType.
     * 
     * @param coordResolution
     */
    public void setCoordResolution(nvo_coords.CoordSpectralValueType coordResolution) {
        this.coordResolution = coordResolution;
    }


    /**
     * Gets the coordSize value for this CoordSpectralType.
     * 
     * @return coordSize
     */
    public nvo_coords.CoordSpectralValueType getCoordSize() {
        return coordSize;
    }


    /**
     * Sets the coordSize value for this CoordSpectralType.
     * 
     * @param coordSize
     */
    public void setCoordSize(nvo_coords.CoordSpectralValueType coordSize) {
        this.coordSize = coordSize;
    }


    /**
     * Gets the coordPixsize value for this CoordSpectralType.
     * 
     * @return coordPixsize
     */
    public nvo_coords.CoordSpectralValueType getCoordPixsize() {
        return coordPixsize;
    }


    /**
     * Sets the coordPixsize value for this CoordSpectralType.
     * 
     * @param coordPixsize
     */
    public void setCoordPixsize(nvo_coords.CoordSpectralValueType coordPixsize) {
        this.coordPixsize = coordPixsize;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof CoordSpectralType)) return false;
        CoordSpectralType other = (CoordSpectralType) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.name==null && other.getName()==null) || 
             (this.name!=null &&
              this.name.equals(other.getName()))) &&
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
              this.coordPixsize.equals(other.getCoordPixsize())));
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
        if (getName() != null) {
            _hashCode += getName().hashCode();
        }
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
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(CoordSpectralType.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("urn:nvo-coords", "coordSpectralType"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("name");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:nvo-coords", "Name"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("coordValue");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:nvo-coords", "CoordValue"));
        elemField.setXmlType(new javax.xml.namespace.QName("urn:nvo-coords", "coordSpectralValueType"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("coordError");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:nvo-coords", "CoordError"));
        elemField.setXmlType(new javax.xml.namespace.QName("urn:nvo-coords", "coordSpectralValueType"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("coordResolution");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:nvo-coords", "CoordResolution"));
        elemField.setXmlType(new javax.xml.namespace.QName("urn:nvo-coords", "coordSpectralValueType"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("coordSize");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:nvo-coords", "CoordSize"));
        elemField.setXmlType(new javax.xml.namespace.QName("urn:nvo-coords", "coordSpectralValueType"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("coordPixsize");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:nvo-coords", "CoordPixsize"));
        elemField.setXmlType(new javax.xml.namespace.QName("urn:nvo-coords", "coordSpectralValueType"));
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
