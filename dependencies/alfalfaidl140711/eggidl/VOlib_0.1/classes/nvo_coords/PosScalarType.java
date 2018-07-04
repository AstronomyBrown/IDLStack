/**
 * PosScalarType.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.2beta Mar 31, 2004 (12:47:03 EST) WSDL2Java emitter.
 */

package nvo_coords;

public class PosScalarType  extends nvo_coords.PosCoordType  implements java.io.Serializable {
    private nvo_coords.CoordValueType coordValue;
    private nvo_coords.CoordValueType coordError;
    private nvo_coords.CoordValueType coordResolution;
    private nvo_coords.CoordValueType coordSize;
    private nvo_coords.CoordValueType coordPixsize;

    public PosScalarType() {
    }


    /**
     * Gets the coordValue value for this PosScalarType.
     * 
     * @return coordValue
     */
    public nvo_coords.CoordValueType getCoordValue() {
        return coordValue;
    }


    /**
     * Sets the coordValue value for this PosScalarType.
     * 
     * @param coordValue
     */
    public void setCoordValue(nvo_coords.CoordValueType coordValue) {
        this.coordValue = coordValue;
    }


    /**
     * Gets the coordError value for this PosScalarType.
     * 
     * @return coordError
     */
    public nvo_coords.CoordValueType getCoordError() {
        return coordError;
    }


    /**
     * Sets the coordError value for this PosScalarType.
     * 
     * @param coordError
     */
    public void setCoordError(nvo_coords.CoordValueType coordError) {
        this.coordError = coordError;
    }


    /**
     * Gets the coordResolution value for this PosScalarType.
     * 
     * @return coordResolution
     */
    public nvo_coords.CoordValueType getCoordResolution() {
        return coordResolution;
    }


    /**
     * Sets the coordResolution value for this PosScalarType.
     * 
     * @param coordResolution
     */
    public void setCoordResolution(nvo_coords.CoordValueType coordResolution) {
        this.coordResolution = coordResolution;
    }


    /**
     * Gets the coordSize value for this PosScalarType.
     * 
     * @return coordSize
     */
    public nvo_coords.CoordValueType getCoordSize() {
        return coordSize;
    }


    /**
     * Sets the coordSize value for this PosScalarType.
     * 
     * @param coordSize
     */
    public void setCoordSize(nvo_coords.CoordValueType coordSize) {
        this.coordSize = coordSize;
    }


    /**
     * Gets the coordPixsize value for this PosScalarType.
     * 
     * @return coordPixsize
     */
    public nvo_coords.CoordValueType getCoordPixsize() {
        return coordPixsize;
    }


    /**
     * Sets the coordPixsize value for this PosScalarType.
     * 
     * @param coordPixsize
     */
    public void setCoordPixsize(nvo_coords.CoordValueType coordPixsize) {
        this.coordPixsize = coordPixsize;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof PosScalarType)) return false;
        PosScalarType other = (PosScalarType) obj;
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
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(PosScalarType.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("urn:nvo-coords", "posScalarType"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("coordValue");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:nvo-coords", "CoordValue"));
        elemField.setXmlType(new javax.xml.namespace.QName("urn:nvo-coords", "coordValueType"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("coordError");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:nvo-coords", "CoordError"));
        elemField.setXmlType(new javax.xml.namespace.QName("urn:nvo-coords", "coordValueType"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("coordResolution");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:nvo-coords", "CoordResolution"));
        elemField.setXmlType(new javax.xml.namespace.QName("urn:nvo-coords", "coordValueType"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("coordSize");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:nvo-coords", "CoordSize"));
        elemField.setXmlType(new javax.xml.namespace.QName("urn:nvo-coords", "coordValueType"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("coordPixsize");
        elemField.setXmlName(new javax.xml.namespace.QName("urn:nvo-coords", "CoordPixsize"));
        elemField.setXmlType(new javax.xml.namespace.QName("urn:nvo-coords", "coordValueType"));
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
